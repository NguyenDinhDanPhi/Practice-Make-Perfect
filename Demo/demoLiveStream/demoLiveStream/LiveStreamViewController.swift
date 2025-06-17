import UIKit
import HaishinKit
import AVFoundation
import VideoToolbox

/// LiveStreamViewController: hiển thị preview camera và stream lên RTMP server.
/// Khởi tạo với streamURL (ví dụ "rtmps://dev-rtmp.fangtv.vn:1935/live") và streamKey (key do server cung cấp).
class LiveStreamViewController: UIViewController {
    // MARK: - Properties

    private let rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var hkView: MTHKView!
    private let startButton = UIButton(type: .system)
    private var isStreaming = false

    private let streamURL: String
    private let streamKey: String

    // Để theo dõi orientation
    private var isObservingOrientation = false

    // MARK: - Init

    init(streamURL: String, streamKey: String) {
        self.streamURL = streamURL
        self.streamKey = streamKey
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingDeviceOrientation()
    }

    deinit {
        stopObservingDeviceOrientation()
    }

    // MARK: - Setup Preview

    private func setupPreview() {
        // Tạo MTHKView để hiển thị preview camera
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

    // MARK: - Setup UI

    private func setupUI() {
        // Nút Start/Stop Stream
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

    // MARK: - Setup Stream

    private func setupStream() {
        // 1. Cấu hình AVAudioSession
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setPreferredSampleRate(44_100)
            //Bạn có thể setPreferredIOBufferDuration nếu cần latency thấp
            //try session.setPreferredIOBufferDuration(0.02)
            try session.setActive(true)
        } catch {
            print("Lỗi AVAudioSession:", error)
        }

        // 2. Khởi tạo RTMPStream
        rtmpStream = RTMPStream(connection: rtmpConnection)

        // 3. Cấu hình capture: sessionPreset, frameRate
        //  .hd1280x720 cho capture 720p. Nếu muốn stream portrait: vẫn dùng hd1280x720 nhưng lưu ý encode videoSize swap width/height khi set videoSettings.
        rtmpStream.sessionPreset = .hd1280x720
        rtmpStream.frameRate = 30

        // 4. Attach camera với autofocus/exposure/stabilization
        if let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            // Cấu hình focus/exposure trước khi attach
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
            // Attach camera
            rtmpStream.attachCamera(cameraDevice, track: 0) { [weak self] videoUnit, error in
                if let e = error {
                    print("Camera attach lỗi:", e)
                } else if let vu = videoUnit {
                    // Mirror nếu front camera
                    vu.isVideoMirrored = true
                    // Stabilization nếu hỗ trợ
                    if vu.preferredVideoStabilizationMode != .off {
                        vu.preferredVideoStabilizationMode = .standard
                    }
                    // Không cần set orientation trên videoUnit, ta set orientation ở rtmpStream phía dưới
                }
                // Sau khi attach camera, ta có thể đảm bảo preview và encoder đã sẵn sàng.
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

        // 6. Preview: attach stream vào hkView
        hkView.attachStream(rtmpStream)

        // 7. Cấu hình encode video:
        // Giả sử muốn stream portrait 720p: videoSize width=720, height=1280
        // Nếu muốn landscape: width=1280, height=720 và set videoOrientation tương ứng
        let isPortrait = true
        if isPortrait {
            // Stream dọc
            let w = 720
            let h = 1280
            rtmpStream.videoSettings = VideoCodecSettings(
                videoSize: .init(width: w, height: h),
                bitRate: 2_500_000,                          // bitrate ~2.5 Mbps
                profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
                maxKeyFrameIntervalDuration: 2               // GOP = 2s
            )
            rtmpStream.videoOrientation = .portrait
        } else {
            // Stream ngang
            let w = 1280
            let h = 720
            rtmpStream.videoSettings = VideoCodecSettings(
                videoSize: .init(width: w, height: h),
                bitRate: 2_500_000,
                profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
                maxKeyFrameIntervalDuration: 2
            )
            // Chọn landscapeRight hoặc landscapeLeft tùy hướng UI/UX
            rtmpStream.videoOrientation = .landscapeRight
        }

        // 8. Cấu hình encode audio
        rtmpStream.audioSettings = AudioCodecSettings(bitRate: 128_000) // 128kbps

        // 9. Lắng nghe trạng thái RTMP
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
    }

    // MARK: - Device Orientation

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
        let deviceOrientation = UIDevice.current.orientation
        var videoOrientation: AVCaptureVideoOrientation?

        switch deviceOrientation {
        case .portrait:
            videoOrientation = .portrait
        case .portraitUpsideDown:
            videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            // Chú ý: khi deviceOrientation = landscapeLeft, thường videoOrientation phải là .landscapeRight để khớp chiều camera
            videoOrientation = .landscapeRight
        case .landscapeRight:
            videoOrientation = .landscapeLeft
        default:
            // .faceUp, .faceDown, .unknown: bỏ qua
            break
        }

        if let vo = videoOrientation {
            // Cập nhật orientation encoder ngay khi stream chưa bắt đầu hoặc đang streaming
            rtmpStream.videoOrientation = vo

            // Nếu muốn thay đổi resolution động:
            // Ví dụ: khi chuyển giữa portrait <-> landscape, ta có thể tái set videoSettings:
            /*
            if vo.isPortrait {
                rtmpStream.videoSettings = VideoCodecSettings(
                    videoSize: .init(width: 720, height: 1280),
                    bitRate: 2_500_000,
                    profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
                    maxKeyFrameIntervalDuration: 2
                )
            } else {
                rtmpStream.videoSettings = VideoCodecSettings(
                    videoSize: .init(width: 1280, height: 720),
                    bitRate: 2_500_000,
                    profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
                    maxKeyFrameIntervalDuration: 2
                )
            }
            */
        }
    }

    // MARK: - Start / Stop Stream

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
        // Kết nối RTMP
        rtmpConnection.connect(streamURL)
        DispatchQueue.main.async {
            self.startButton.isEnabled = false
            self.startButton.setTitle("Đang kết nối...", for: .normal)
        }
    }

    @objc private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        if let data = e.data as? ASObject, let code = data["code"] as? String {
            print("RTMP Status: \(code)")
            switch code {
            case RTMPConnection.Code.connectSuccess.rawValue:
                // Khi kết nối thành công, publish với streamKey
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
        // Xảy ra lỗi IO khi streaming
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
        // Nếu chỉ muốn portrait: return .portrait
        // Nếu muốn hỗ trợ xoay: return .allButUpsideDown hoặc .all
        return .allButUpsideDown
    }
}
