import UIKit
import AVFoundation
import AVKit

class EditViewController: UIViewController {

    // MARK: - Inputs
    private let sourceURL: URL
    init(sourceURL: URL) {
        self.sourceURL = sourceURL
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - UI Components
    private let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!

    private let startSlider = UISlider()
    private let endSlider   = UISlider()
    private let addTextBtn  = UIButton(type: .system)
    private let drawBtn     = UIButton(type: .system)
    private let saveBtn     = UIButton(type: .system)

    // Overlays
    private var textOverlays: [String] = []
    private var drawingOverlay: CALayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerView()
        setupPlayer()
        setupControls()
    }

    private func setupPlayerView() {
        view.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 9.0/16.0)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Cập nhật lại frame cho playerLayer
        playerLayer.frame = playerView.bounds
    }


    private func setupPlayer() {
        player = AVPlayer(url: sourceURL)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playerView.bounds
        playerLayer.videoGravity = .resizeAspect
        playerView.layer.addSublayer(playerLayer)
        player.play()
    }

    private func setupControls() {
        let duration = CMTimeGetSeconds(AVAsset(url: sourceURL).duration)
        [startSlider, endSlider].forEach {
            $0.minimumValue = 0
            $0.maximumValue = Float(duration)
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        endSlider.value = Float(duration)

        addTextBtn.setTitle("Thêm chữ", for: .normal)
        drawBtn.setTitle("Vẽ", for: .normal)
        saveBtn.setTitle("Lưu", for: .normal)
        [addTextBtn, drawBtn, saveBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        addTextBtn.addTarget(self, action: #selector(addText), for: .touchUpInside)
        drawBtn.addTarget(self, action: #selector(startDrawing), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveEdited), for: .touchUpInside)

        NSLayoutConstraint.activate([
            startSlider.topAnchor.constraint(equalTo: playerView.bottomAnchor, constant: 16),
            startSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            startSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            endSlider.topAnchor.constraint(equalTo: startSlider.bottomAnchor, constant: 8),
            endSlider.leadingAnchor.constraint(equalTo: startSlider.leadingAnchor),
            endSlider.trailingAnchor.constraint(equalTo: startSlider.trailingAnchor),

            addTextBtn.topAnchor.constraint(equalTo: endSlider.bottomAnchor, constant: 16),
            addTextBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            drawBtn.centerYAnchor.constraint(equalTo: addTextBtn.centerYAnchor),
            drawBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            saveBtn.centerYAnchor.constraint(equalTo: addTextBtn.centerYAnchor),
            saveBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    @objc private func addText() {
        let alert = UIAlertController(title: "Nhập chữ", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            if let txt = alert.textFields?.first?.text, !txt.isEmpty {
                self.textOverlays.append(txt)
            }
        })
        alert.addAction(UIAlertAction(title: "Huỷ", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func startDrawing() {
        let drawing = DrawingView(frame: playerView.frame)
        view.addSubview(drawing)
        drawing.onFinish = { layer in
            self.drawingOverlay = layer
            drawing.removeFromSuperview()
        }
    }

    @objc private func saveEdited() {
        let start = CMTime(seconds: Double(startSlider.value), preferredTimescale: 600)
        let end   = CMTime(seconds: Double(endSlider.value), preferredTimescale: 600)
        trimVideo(sourceURL: sourceURL, start: start, end: end) { trimmedURL in
            guard let trimmed = trimmedURL else { return }
            self.addTextOverlay(sourceURL: trimmed, texts: self.textOverlays) { textedURL in
                guard let txted = textedURL else { return }
                self.addDrawingOverlay(sourceURL: txted, drawingLayer: self.drawingOverlay) { finalURL in
                    guard let out = finalURL else { return }
                    DispatchQueue.main.async {
                        let playerVC = AVPlayerViewController()
                        playerVC.player = AVPlayer(url: out)
                        // Trong completion của addDrawingOverlay, trước khi present player:
                       try? VideoManager.shared.saveVideo(at: out)

                   }
                }
            }
        }
        
        
    }

    // MARK: - Processing Methods
    private func trimVideo(sourceURL: URL, start: CMTime, end: CMTime, completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: sourceURL)
        guard let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil); return
        }
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("trimmed_\(Int(Date().timeIntervalSince1970)).mp4")
        session.outputURL = outputURL
        session.outputFileType = .mp4
        session.timeRange = CMTimeRange(start: start, end: end)
        session.exportAsynchronously {
            completion(session.status == .completed ? outputURL : nil)
        }
    }

    private func addTextOverlay(sourceURL: URL, texts: [String], completion: @escaping (URL?) -> Void) {
        let asset = AVAsset(url: sourceURL)
        let composition = AVMutableComposition()
        guard let videoTrack = asset.tracks(withMediaType: .video).first,
              let compTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        else { completion(nil); return }
        try? compTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: videoTrack, at: .zero)
        compTrack.preferredTransform = videoTrack.preferredTransform

        let videoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(origin: .zero, size: videoSize)
        let videoLayer = CALayer()
        videoLayer.frame = parentLayer.bounds
        parentLayer.addSublayer(videoLayer)

        for (i, txt) in texts.enumerated() {
            let textLayer = CATextLayer()
            textLayer.string = txt
            textLayer.foregroundColor = UIColor.white.cgColor
            textLayer.fontSize = 48
            textLayer.alignmentMode = .center
            textLayer.frame = CGRect(x: 0, y: CGFloat(i) * 60 + 50, width: videoSize.width, height: 60)
            parentLayer.addSublayer(textLayer)
        }

        let videoComp = AVMutableVideoComposition()
        videoComp.renderSize = videoSize
        videoComp.frameDuration = CMTime(value: 1, timescale: 30)
        videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: asset.duration)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compTrack)
        instruction.layerInstructions = [layerInstruction]
        videoComp.instructions = [instruction]

        guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil); return
        }
        let outURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("texted_\(Int(Date().timeIntervalSince1970)).mp4")
        export.videoComposition = videoComp
        export.outputURL = outURL
        export.outputFileType = .mp4
        export.exportAsynchronously { completion(export.status == .completed ? outURL : nil) }
    }

    private func addDrawingOverlay(sourceURL: URL, drawingLayer: CALayer?, completion: @escaping (URL?) -> Void) {
        guard let drawLayer = drawingLayer else { completion(sourceURL); return }
        let asset = AVAsset(url: sourceURL)
        let composition = AVMutableComposition()
        guard let videoTrack = asset.tracks(withMediaType: .video).first,
              let compTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        else { completion(nil); return }
        try? compTrack.insertTimeRange(CMTimeRange(start: .zero, duration: asset.duration), of: videoTrack, at: .zero)
        compTrack.preferredTransform = videoTrack.preferredTransform

        let videoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
        let parentLayer = CALayer()
        parentLayer.frame = CGRect(origin: .zero, size: videoSize)
        let videoLayer = CALayer()
        videoLayer.frame = parentLayer.bounds
        parentLayer.addSublayer(videoLayer)

        drawLayer.frame = parentLayer.bounds
        parentLayer.addSublayer(drawLayer)

        let videoComp = AVMutableVideoComposition()
        videoComp.renderSize = videoSize
        videoComp.frameDuration = CMTime(value: 1, timescale: 30)
        videoComp.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: asset.duration)
        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compTrack)
        instruction.layerInstructions = [layerInstruction]
        videoComp.instructions = [instruction]

        guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
            completion(nil); return
        }
        let outURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("final_\(Int(Date().timeIntervalSince1970)).mp4")
        export.videoComposition = videoComp
        export.outputURL = outURL
        export.outputFileType = .mp4
        export.exportAsynchronously { completion(export.status == .completed ? outURL : nil) }
    }
}

// Note: Implement `DrawingView` separately with `onFinish` callback providing its layer.
class DrawingView: UIView {
    /// Gọi khi user hoàn thành vẽ (ví dụ lift finger 2 lần hoặc double tap)
    var onFinish: ((CALayer) -> Void)?
    private var path = UIBezierPath()
    private var shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupShapeLayer()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShapeLayer()
    }

    private func setupShapeLayer() {
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = nil
        layer.addSublayer(shapeLayer)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pt = touches.first?.location(in: self) else { return }
        path = UIBezierPath()
        path.move(to: pt)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pt = touches.first?.location(in: self) else { return }
        path.addLine(to: pt)
        shapeLayer.path = path.cgPath
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gọi callback khi user kết thúc 1 lần vẽ
        onFinish?(shapeLayer)
    }
}
