import UIKit
import AVFoundation
import HaishinKit

class LiveStreamViewController: UIViewController {
    // MARK: - Properties
    private let rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var hkView: MTHKView!
    private let startButton = UIButton(type: .system)
    private var isStreaming = false
    
    // MediaMixer để capture camera/audio
    private var mediaMixer: MediaMixer?
    
    private let streamURL: String
    private let streamKey: String
    
    private var isObservingOrientation = false
    
    // MARK: - Init
    init(streamURL: String, streamKey: String) {
        self.streamURL = streamURL
        self.streamKey = streamKey
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) chưa dùng")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPreview()
        setupUI()
        
        // Không setup stream ngay, đợi viewDidAppear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startObservingDeviceOrientation()
        
        // Setup stream sau khi view đã appear
        Task {
            await setupStreamAsync()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingDeviceOrientation()
        
        // Stop mọi thứ
        Task {
            await cleanup()
        }
    }
    
    deinit {
        stopObservingDeviceOrientation()
        Task {
            await cleanup()
        }
    }
    
    // MARK: - Preview Setup
    private func setupPreview() {
        hkView = MTHKView(frame: view.bounds)
        hkView.videoGravity = .resizeAspectFill
        hkView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hkView)
        NSLayoutConstraint.activate([
            hkView.topAnchor.constraint(equalTo: view.topAnchor),
            hkView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hkView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hkView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        startButton.setTitle("Bắt đầu Stream", for: .normal)
        startButton.tintColor = .white
        startButton.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        startButton.layer.cornerRadius = 8
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(toggleStream), for: .touchUpInside)
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 160),
            startButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Stream Setup
    private func setupStreamAsync() async {
        print("🎬 Starting stream setup...")
        
        do {
            // 1. Request permissions
            let hasPermissions = await requestPermissions()
            guard hasPermissions else {
                await showAlert(title: "Lỗi", message: "Cần cấp quyền camera và microphone")
                return
            }
            
            // 2. Setup audio session
            try setupAudioSession()
            
            // 3. Setup MediaMixer và connections
            try await setupMediaMixerAndConnections()
            
            // 4. Attach devices
            try await attachDevices()
            
            // 5. Configure settings
            await MainActor.run {
                configureStreamSettings()
            }
            
            print("✅ Stream setup completed")
            
        } catch {
            print("❌ Stream setup failed: \(error)")
            await showAlert(title: "Lỗi", message: "Không thể khởi tạo camera: \(error.localizedDescription)")
        }
    }
    
    private func requestPermissions() async -> Bool {
        // Check camera permission
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let cameraGranted: Bool
        
        switch cameraStatus {
        case .authorized:
            cameraGranted = true
        case .notDetermined:
            cameraGranted = await AVCaptureDevice.requestAccess(for: .video)
        default:
            cameraGranted = false
        }
        
        // Check audio permission
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        let audioGranted: Bool
        
        switch audioStatus {
        case .authorized:
            audioGranted = true
        case .notDetermined:
            audioGranted = await AVCaptureDevice.requestAccess(for: .audio)
        default:
            audioGranted = false
        }
        
        print("🔐 Permissions - Camera: \(cameraGranted), Audio: \(audioGranted)")
        return cameraGranted && audioGranted
    }
    
    private func setupAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
        try session.setPreferredSampleRate(44_100)
        try session.setActive(true)
        print("🔊 Audio session configured")
    }
    
    private func setupMediaMixerAndConnections() async throws {
        print("📹 Setting up MediaMixer and connections...")
        
        // 1. Create MediaMixer
        mediaMixer = MediaMixer()
        
        guard let mediaMixer = mediaMixer else {
            throw NSError(domain: "MediaMixer", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create MediaMixer"])
        }
        
        // 2. Create RTMPStream on main thread
        await MainActor.run {
            rtmpStream = RTMPStream(connection: rtmpConnection)
            setupConnectionListeners()
        }
        
        // 3. Add outputs (these are async calls)
        try await mediaMixer.addOutput(hkView)
        print("✅ Preview connected")
        
        try await mediaMixer.addOutput(rtmpStream)
        print("✅ Stream output connected")
    }
    
    private func attachDevices() async throws {
        guard let mediaMixer = mediaMixer else {
            throw NSError(domain: "MediaMixer", code: -1, userInfo: [NSLocalizedDescriptionKey: "MediaMixer not initialized"])
        }
        
        // Attach camera
        if let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            try await attachCamera(cameraDevice, to: mediaMixer)
        } else {
            print("⚠️ No camera found")
        }
        
        // Attach microphone
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            try await attachAudio(audioDevice, to: mediaMixer)
        } else {
            print("⚠️ No microphone found")
        }
    }
    
    private func attachCamera(_ device: AVCaptureDevice, to mixer: MediaMixer) async throws {
        print("📸 Attaching camera...")
        
        try device.lockForConfiguration()
        defer { device.unlockForConfiguration() }
        
        if device.isFocusModeSupported(.continuousAutoFocus) {
            device.focusMode = .continuousAutoFocus
        }
        if device.isExposureModeSupported(.continuousAutoExposure) {
            device.exposureMode = .continuousAutoExposure
        }
        
        try await mixer.attachVideo(device)
        print("✅ Camera attached")
    }
    
    private func attachAudio(_ device: AVCaptureDevice, to mixer: MediaMixer) async throws {
        print("🎤 Attaching audio...")
        try await mixer.attachAudio(device)
        print("✅ Audio attached")
    }
    
    private func configureStreamSettings() {
        guard let rtmpStream = rtmpStream else { return }
        
        // Video settings
        var videoSettings = VideoCodecSettings()
        videoSettings.bitRate = 2_500_000
        videoSettings.videoSize = CGSize(width: 1280, height: 720)
        videoSettings.maxKeyFrameIntervalDuration = 2
        rtmpStream.setVideoSettings(videoSettings)
        
        // Audio settings
        var audioSettings = AudioCodecSettings()
        audioSettings.bitRate = 128_000
        rtmpStream.setAudioSettings(audioSettings)
        
        print("⚙️ Stream settings configured")
    }
    
    private func setupConnectionListeners() {
        guard let rtmpStream = rtmpStream else { return }
        
        Task {
            for await status in rtmpStream.status {
                await MainActor.run {
                    self.handleRTMPStatus(status)
                }
            }
        }
    }
    
    private func handleRTMPStatus(_ status: RTMPStatus) {
        print("📡 RTMP Status: \(status.code) - \(status.description)")
        
        switch status.code {
        case RTMPStream.Code.publishStart.rawValue:
            print("✅ Stream started successfully")
        case RTMPStream.Code.unpublishSuccess.rawValue:
            print("✅ Stream stopped successfully")
        case RTMPStream.Code.connectFailed.rawValue,
             RTMPStream.Code.publishBadName.rawValue:
            showAlert(title: "Lỗi Stream", message: status.description)
            isStreaming = false
            startButton.setTitle("Bắt đầu Stream", for: .normal)
            startButton.isEnabled = true
        default:
            break
        }
    }
    
    // MARK: - Cleanup
    private func cleanup() async {
        print("🧹 Cleaning up...")
        
        if isStreaming {
            try? await rtmpStream?.close()
            try? await rtmpConnection.close()
        }
        
        mediaMixer = nil
        print("✅ Cleanup completed")
    }
    
    // MARK: - Stream Control
    @objc private func toggleStream() {
        if isStreaming {
            Task { await stopStream() }
        } else {
            Task { await startStream() }
        }
    }
    
    private func startStream() async {
        guard !streamURL.isEmpty, mediaMixer != nil else {
            await showAlert(title: "Lỗi", message: "Stream chưa sẵn sàng")
            return
        }
        
        await MainActor.run {
            startButton.isEnabled = false
            startButton.setTitle("Đang kết nối...", for: .normal)
        }
        
        do {
            _ = try await rtmpConnection.connect(streamURL)
            _ = try await rtmpStream.publish(streamKey)
            
            await MainActor.run {
                self.isStreaming = true
                self.startButton.isEnabled = true
                self.startButton.setTitle("Dừng Stream", for: .normal)
            }
        } catch {
            await MainActor.run {
                self.isStreaming = false
                self.startButton.isEnabled = true
                self.startButton.setTitle("Bắt đầu Stream", for: .normal)
            }
            await showAlert(title: "Lỗi", message: "Không kết nối được: \(error.localizedDescription)")
        }
    }
    
    private func stopStream() async {
        do {
            _ = try await rtmpStream.close()
            _ = try await rtmpConnection.close()
            
            await MainActor.run {
                self.isStreaming = false
                self.startButton.setTitle("Bắt đầu Stream", for: .normal)
            }
        } catch {
            print("❌ Stop stream error: \(error)")
        }
    }
    
    // MARK: - Orientation
    private func startObservingDeviceOrientation() {
        guard !isObservingOrientation else { return }
        isObservingOrientation = true
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deviceOrientationDidChange),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    private func stopObservingDeviceOrientation() {
        guard isObservingOrientation else { return }
        isObservingOrientation = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    @objc private func deviceOrientationDidChange() {
        applyCurrentOrientationToStream()
    }
    
    private func applyCurrentOrientationToStream() {
        guard let rtmpStream = rtmpStream else { return }
        
        let deviceOrientation = UIDevice.current.orientation
        let isPortrait: Bool
        
        switch deviceOrientation {
        case .portrait, .portraitUpsideDown:
            isPortrait = true
        case .landscapeLeft, .landscapeRight:
            isPortrait = false
        default:
            return
        }
        
        let size = isPortrait ? CGSize(width: 720, height: 1280) : CGSize(width: 1280, height: 720)
        var videoSettings = rtmpStream.videoSettings
        videoSettings.videoSize = size
        rtmpStream.setVideoSettings(videoSettings)
    }
    
    // MARK: - Alert Helper
    @MainActor
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}
