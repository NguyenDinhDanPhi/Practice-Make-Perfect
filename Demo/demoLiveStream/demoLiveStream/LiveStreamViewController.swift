import UIKit
import HaishinKit
import AVFoundation
import VideoToolbox

class LiveStreamViewController: UIViewController {
    private let rtmpConnection = RTMPConnection()
    private var rtmpStream: RTMPStream!
    private var hkView: MTHKView!
    private let startButton = UIButton(type: .system)
    private var isStreaming = false

    private let streamURL: String
    private let streamKey: String

    init(streamURL: String, streamKey: String) {
        self.streamURL = streamURL
        self.streamKey = streamKey
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupPreview()
        setupUI()
        setupStream()
    }

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

    private func setupStream() {
        // AVAudioSession
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        try? session.setActive(true)

        // RTMPStream
        rtmpStream = RTMPStream(connection: rtmpConnection)

        // captureSettings
        rtmpStream.sessionPreset = .iFrame1280x720
        rtmpStream.frameRate = 30

        // attachAudio: closure có 2 tham số
        if let audioDevice = AVCaptureDevice.default(for: .audio) {
            rtmpStream.attachAudio(audioDevice) { audioUnit, error in
                if let e = error {
                    print("Audio attach lỗi: \(e)")
                }
            }
        }

        // attachCamera: closure có 2 tham số
        if let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            rtmpStream.attachCamera(cameraDevice, track: 0) { videoUnit, error in
                if let e = error {
                    print("Camera attach lỗi: \(e)")
                } else {
                    videoUnit?.isVideoMirrored = true
                }
            }
        }

        // Preview
        hkView.attachStream(rtmpStream)

        // videoSettings bằng dictionary
        rtmpStream.videoSettings = VideoCodecSettings(
            videoSize: .init(width: 1280, height: 720),
            bitRate: 1_500_000,
            profileLevel: kVTProfileLevel_H264_Main_AutoLevel as String,
            maxKeyFrameIntervalDuration: 1
        )

        // Tương tự audioSettings:
        rtmpStream.audioSettings = AudioCodecSettings(bitRate: 64_000)

        // Event listener
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self)
        rtmpConnection.addEventListener(.ioError, selector: #selector(rtmpErrorHandler), observer: self)
    }

    @objc private func toggleStream() {
        if isStreaming { stopStream() } else { startStream() }
    }
    private func startStream() {
        guard !streamURL.isEmpty else { showAlert(title: "Lỗi", message: "URL không hợp lệ."); return }
        rtmpConnection.connect(streamURL)
        startButton.isEnabled = false
        startButton.setTitle("Đang kết nối...", for: .normal)
    }
    @objc private func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        if let data = e.data as? ASObject, let code = data["code"] as? String {
            print("RTMP Status: \(code)")
            if code == RTMPConnection.Code.connectSuccess.rawValue {
                rtmpStream.publish(streamKey)
                DispatchQueue.main.async {
                    self.isStreaming = true
                    self.startButton.isEnabled = true
                    self.startButton.setTitle("Dừng Stream", for: .normal)
                }
            } else if code == RTMPConnection.Code.connectFailed.rawValue ||
                      code == RTMPConnection.Code.connectClosed.rawValue {
                DispatchQueue.main.async {
                    self.isStreaming = false
                    self.startButton.isEnabled = true
                    self.startButton.setTitle("Bắt đầu Stream", for: .normal)
                    self.showAlert(title: "Lỗi", message: "Không kết nối được server.")
                }
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
        isStreaming = false
        startButton.setTitle("Bắt đầu Stream", for: .normal)
    }
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(.init(title: "OK", style: .default))
            self.present(ac, animated: true)
        }
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}
