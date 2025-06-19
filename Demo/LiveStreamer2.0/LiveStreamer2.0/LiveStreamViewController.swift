import UIKit
import AVFoundation
import HaishinKit

class LiveStreamViewController: UIViewController {
    // MARK: - Properties
    private let rtmpConnection = RTMPConnection() // Kết nối RTMP
    private var rtmpStream: RTMPStream!           // RTMPStream để publish
    private var hkView: MTHKView!                 // Preview view
    private let startButton = UIButton(type: .system)
    private var isStreaming = false               // Trạng thái streaming
    
    // MediaMixer để capture camera/audio
    private var mediaMixer: MediaMixer?
    // Lưu videoUnit nếu cần (kiểu public do HaishinKit cung cấp); nếu không rõ, dùng Any
    private var videoCaptureUnitTrack0: Any?
    
    private let streamURL: String  // URL RTMP server
    private let streamKey: String  // stream key
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startObservingDeviceOrientation()
        Task {
            await setupStreamAsync()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingDeviceOrientation()
        Task {
            await cleanup()
        }
    }
    deinit {
        stopObservingDeviceOrientation()
        Task { await cleanup() }
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
            let hasPermissions = await requestPermissions()
            guard hasPermissions else {
                showAlert(title: "Lỗi", message: "Cần cấp quyền camera và microphone")
                return
            }
            try setupAudioSession()
            try await setupMediaMixerAndConnections()
            try await attachDevices() // Phần cấu hình sessionPreset và frameRate
            // Configure codec settings ban đầu
            await MainActor.run {
                configureStreamSettings()
            }
            // Áp orientation khởi tạo
            applyCurrentOrientationToStream()
            print("✅ Stream setup completed")
        } catch {
            print("❌ Stream setup failed:", error)
            showAlert(title: "Lỗi", message: error.localizedDescription)
        }
    }
    
    private func requestPermissions() async -> Bool {
        // Camera
        let cameraGranted: Bool = await {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: return true
            case .notDetermined: return await AVCaptureDevice.requestAccess(for: .video)
            default: return false
            }
        }()
        // Microphone
        let audioGranted: Bool = await {
            switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized: return true
            case .notDetermined: return await AVCaptureDevice.requestAccess(for: .audio)
            default: return false
            }
        }()
        let cam = await cameraGranted, mic = await audioGranted
        print("🔐 Permissions - Camera: \(cam), Audio: \(mic)")
        return cam && mic
    }
    
    private func setupAudioSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .default,
                                options: [.defaultToSpeaker, .allowBluetooth])
        try session.setPreferredSampleRate(44_100)
        try session.setActive(true)
        print("🔊 Audio session configured")
    }
    
    private func setupMediaMixerAndConnections() async throws {
        // Tạo MediaMixer
        mediaMixer = MediaMixer()
        guard let mediaMixer = mediaMixer else {
            throw NSError(domain: "MediaMixer", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "MediaMixer not initialized"])
        }
        // Tạo RTMPStream trên MainActor
        await MainActor.run {
            rtmpStream = RTMPStream(connection: rtmpConnection)
            setupConnectionListeners()
        }
        // Add outputs cho preview và stream
        await mediaMixer.addOutput(hkView)
        print("✅ Preview connected")
        await mediaMixer.addOutput(rtmpStream)
        print("✅ Stream output connected")
    }
    
    private func attachDevices() async throws {
        guard let mediaMixer = mediaMixer else {
            throw NSError(domain: "MediaMixer", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "MediaMixer not initialized"])
        }
  
        await mediaMixer.setFrameRate(30)
        await mediaMixer.setSessionPreset(AVCaptureSession.Preset.medium)
        await mediaMixer.configuration { session in
            session.automaticallyConfiguresApplicationAudioSession = true
        }
        
        // Attach camera
        if let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            try await mediaMixer.attachVideo(cameraDevice, track: 0) { videoUnit in
                // videoUnit kiểu public do HaishinKit cung cấp, không khai VideoIOUnit
                self.videoCaptureUnitTrack0 = videoUnit
                videoUnit.isVideoMirrored = true
                if videoUnit.preferredVideoStabilizationMode != .off {
                    videoUnit.preferredVideoStabilizationMode = .standard
                }
            }
            print("✅ Camera attached")
        } else {
            print("⚠️ No camera found")
        }
        // Attach audio
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            try await mediaMixer.attachAudio(audioDevice, track: 0) { audioUnit in
                // Cấu hình audioUnit nếu cần
            }
            print("✅ Audio attached")
        } else {
            print("⚠️ No microphone found")
        }
    }
    
    private func configureStreamSettings() {
        guard let rtmpStream = rtmpStream else { return }
        var videoSettings = VideoCodecSettings()
        videoSettings.bitRate = 2_500_000
        // Ban đầu kích thước 1280x720, sau cập orientation sẽ set lại
        videoSettings.videoSize = CGSize(width: 1280, height: 720)
        videoSettings.maxKeyFrameIntervalDuration = 2
        rtmpStream.setVideoSettings(videoSettings)
        
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
                    handleRTMPStatus(status)
                }
            }
        }
    }
    
    private func handleRTMPStatus(_ status: RTMPStatus) {
        print("📡 RTMP Status: \(status.code) - \(status.description)")
        switch status.code {
        case RTMPStream.Code.publishStart.rawValue:
            DispatchQueue.main.async {
                self.isStreaming = true
                self.startButton.setTitle("Dừng Stream", for: .normal)
                self.startButton.isEnabled = true
            }
        case RTMPStream.Code.unpublishSuccess.rawValue:
            DispatchQueue.main.async {
                self.isStreaming = false
                self.startButton.setTitle("Bắt đầu Stream", for: .normal)
                self.startButton.isEnabled = true
            }
        case RTMPStream.Code.connectFailed.rawValue,
             RTMPStream.Code.publishBadName.rawValue:
            showAlert(title: "Lỗi Stream", message: status.description)
            DispatchQueue.main.async {
                self.isStreaming = false
                self.startButton.setTitle("Bắt đầu Stream", for: .normal)
                self.startButton.isEnabled = true
            }
        default:
            break
        }
    }
    
    // MARK: - Cleanup
    private func cleanup() async {
        if isStreaming {
            _ = try? await rtmpStream.close()
            _ = try? await rtmpConnection.close()
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
            showAlert(title: "Lỗi", message: "Stream chưa sẵn sàng")
            return
        }
        await MainActor.run {
            startButton.isEnabled = false
            startButton.setTitle("Đang kết nối...", for: .normal)
        }
        do {
            _ = try await rtmpConnection.connect(streamURL)
            _ = try await rtmpStream.publish(streamKey)
        } catch {
            await MainActor.run {
                self.isStreaming = false
                self.startButton.isEnabled = true
                self.startButton.setTitle("Bắt đầu Stream", for: .normal)
            }
            showAlert(title: "Lỗi", message: error.localizedDescription)
        }
    }
    private func stopStream() async {
        await MainActor.run {
            self.isStreaming = false
            self.startButton.setTitle("Bắt đầu Stream", for: .normal)
            self.startButton.isEnabled = true
        }
        _ = try? await rtmpStream.close()
        _ = try? await rtmpConnection.close()
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
        NotificationCenter.default.removeObserver(self,
                                                  name: UIDevice.orientationDidChangeNotification,
                                                  object: nil)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    @objc private func deviceOrientationDidChange() {
        applyCurrentOrientationToStream()
    }
    private func applyCurrentOrientationToStream() {
        guard let mediaMixer = mediaMixer, let rtmpStream = rtmpStream else { return }
        let deviceOrientation = UIDevice.current.orientation
        var vo: AVCaptureVideoOrientation?
        switch deviceOrientation {
        case .portrait: vo = .portrait
        case .portraitUpsideDown: vo = .portraitUpsideDown
        case .landscapeLeft: vo = .landscapeRight
        case .landscapeRight: vo = .landscapeLeft
        default: vo = nil
        }
        if let orientation = vo {
            mediaMixer.setVideoOrientation(orientation)
            // Cập nhật kích thước encoder phù hợp
            let size = (orientation == .portrait || orientation == .portraitUpsideDown)
                ? CGSize(width: 720, height: 1280)
                : CGSize(width: 1280, height: 720)
            var vs = rtmpStream.videoSettings
            vs.videoSize = size
            rtmpStream.setVideoSettings(vs)
        }
    }
    
    @MainActor
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(.init(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}
