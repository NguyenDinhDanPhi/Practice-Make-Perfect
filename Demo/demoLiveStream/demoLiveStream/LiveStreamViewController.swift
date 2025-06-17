import UIKit
import HaishinKit
import AVFoundation
import VideoToolbox

/// LiveStreamViewController: hiển thị preview camera và stream lên RTMP server.
/// Khởi tạo với streamURL (ví dụ "rtmps://dev-rtmp.fangtv.vn:1935/live") và streamKey.
class LiveStreamViewController: UIViewController {
    // MARK: - Properties

    private let rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var hkView: MTHKView!
    private let startButton = UIButton(type: .system)
    private var isStreaming = false

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
        setupStream()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startObservingDeviceOrientation()
        // Thiết lập ban đầu theo orientation hiện tại:
        applyCurrentOrientationToStream()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingDeviceOrientation()
    }

    deinit {
        stopObservingDeviceOrientation()
    }

    // MARK: - Preview

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

    // MARK: - UI

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

    // MARK: - Stream setup

    private func setupStream() {
        // 1. AVAudioSession
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setPreferredSampleRate(44_100)
            // session.setPreferredIOBufferDuration chỉ ảnh hưởng audio local
            try session.setActive(true)
        } catch {
            print("Lỗi AVAudioSession:", error)
        }

        // 2. RTMPStream
        rtmpStream = RTMPStream(connection: rtmpConnection)

        // 3. Capture settings
        rtmpStream.sessionPreset = .hd1280x720
        rtmpStream.frameRate = 30

        // 4. Attach camera với autofocus/exposure/stabilization
        if let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            do {
                try cameraDevice.lockForConfiguration()
                if cameraDevice.isFocusModeSupported(.continuousAutoFocus) {
                    cameraDevice.focusMode = .continuousAutoFocus
                }
                if cameraDevice.isExposureModeSupported(.continuousAutoExposure) {
                    cameraDevice.exposureMode = .continuousAutoExposure
                }
                cameraDevice.unlockForConfiguration()
            } catch {
                print("Không thể cấu hình camera:", error)
            }
            rtmpStream.attachCamera(cameraDevice, track: 0) { videoUnit, error in
                if let e = error {
                    print("Camera attach lỗi:", e)
                } else if let vu = videoUnit {
                    vu.isVideoMirrored = true
                    if vu.preferredVideoStabilizationMode != .off {
                        vu.preferredVideoStabilizationMode = .standard
                    }
                }
            }
        }

        // 5. Attach audio
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            rtmpStream.attachAudio(audioDevice) { audioUnit, error in
                if let e = error {
                    print("Audio attach lỗi:", e)
                }
            }
        }

        // 6. Preview
        hkView.attachStream(rtmpStream)

        // 7. Video encode & orientation: ban đầu sẽ set trong applyCurrentOrientationToStream()
        // 8. Audio encode
        rtmpStream.audioSettings = AudioCodecSettings(bitRate: 128_000)

        // 9. RTMP listeners
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
    }

    // MARK: - Orientation handling

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
        // Lấy orientation thiết bị
        let deviceOrientation = UIDevice.current.orientation
        var videoOrientation: AVCaptureVideoOrientation?
        switch deviceOrientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            // Khi thiết bị quay trái, camera image quay phải
            videoOrientation = .landscapeRight
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        default:
            // faceUp, faceDown, unknown: không đổi
            break
        }
        guard let vo = videoOrientation else { return }

        // Cập nhật orientation encoder
        rtmpStream.videoOrientation = vo

        // Cập nhật videoSettings nếu muốn thay đổi resolution tương ứng
        let isPortrait = (vo == .portrait || vo == .portraitUpsideDown)
        if isPortrait {
            let w = 720
            let h = 1280
            rtmpStream.videoSettings = VideoCodecSettings(
                videoSize: .init(width: w, height: h),
                bitRate: 2_500_000,
                profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
                scalingMode: .trim,
                bitRateMode: .average,
                maxKeyFrameIntervalDuration: 2,
                allowFrameReordering: true,
                isHardwareEncoderEnabled: true
               
            )
        } else {
            let w = 1280
            let h = 720
            rtmpStream.videoSettings = VideoCodecSettings(
                videoSize: .init(width: w, height: h),
                bitRate: 2_500_000,
                profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
                scalingMode: .trim,
                bitRateMode: .average,
                maxKeyFrameIntervalDuration: 2,
                allowFrameReordering: true,
                isHardwareEncoderEnabled: true
               
            )
        }
    }

    // MARK: - Start/Stop Stream

    @objc private func toggleStream() {
        if isStreaming {
            stopStream()
        } else {
            startStream()
        }
    }

    private func startStream() {
        guard !streamURL.isEmpty else {
            showAlert(title: "Lỗi", message: "URL không hợp lệ.")
            return
        }
        rtmpConnection.connect(streamURL)
        DispatchQueue.main.async {
            self.startButton.isEnabled = false
            self.startButton.setTitle("Đang kết nối...", for: .normal)
        }
    }

    @objc private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        if let data = e.data as? ASObject, let code = data["code"] as? String {
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                rtmpStream.publish(streamKey)
                DispatchQueue.main.async {
                    self.isStreaming = true
                    self.startButton.isEnabled = true
                    self.startButton.setTitle("Dừng Stream", for: .normal)
                }
            case RTMPConnection.Code.connectFailed.rawValue, RTMPConnection.Code.connectClosed.rawValue:
                DispatchQueue.main.async {
                    self.isStreaming = false
                    self.startButton.isEnabled = true
                    self.startButton.setTitle("Bắt đầu Stream", for: .normal)
                    self.showAlert(title: "Lỗi", message: "Không kết nối được server.")
                }
            default:
                break
            }
        }
    }

    @objc private func rtmpErrorHandler(_ notification: Notification) {
        DispatchQueue.main.async {
            self.isStreaming = false
            self.startButton.isEnabled = true
            self.startButton.setTitle("Bắt đầu Stream", for: .normal)
            self.showAlert(title: "Lỗi kết nối", message: "Xảy ra lỗi khi streaming.")
        }
    }

    private func stopStream() {
        rtmpStream.close()
        rtmpConnection.close()
        DispatchQueue.main.async {
            self.isStreaming = false
            self.startButton.setTitle("Bắt đầu Stream", for: .normal)
        }
    }

    // MARK: - Alert

    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(.init(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }

    // MARK: - Orientation Support

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        // Cho phép xoay: portrait và landscape
        return .allButUpsideDown
    }
}
