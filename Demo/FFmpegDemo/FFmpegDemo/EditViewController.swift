//
//  EditViewController.swift
//  FFmpegDemo
//
//  Created by Dan Phi on 6/8/25.
//

import UIKit
import AVKit

// MARK: - EditViewController with Story-like Buttons
class EditViewController: UIViewController {
    private let videoURL: URL
    private var playerVC: AVPlayerViewController?
    
    private let trimButton = UIButton(type: .system)
    private let cropButton = UIButton(type: .system)
    private let textButton = UIButton(type: .system)
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Story"
        view.backgroundColor = .black
        setupPlayerView()
        setupActionButtons()
    }
    
    private func setupPlayerView() {
        let player = AVPlayer(url: videoURL)
        let vc = AVPlayerViewController()
        vc.player = player
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        // Layout within safe area
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        ])
        player.play()
        playerVC = vc
    }
    
    private func setupActionButtons() {
        // Configure buttons
        [trimButton, cropButton, textButton].forEach { btn in
            btn.tintColor = .white
            btn.layer.cornerRadius = 30
            btn.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 60).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        trimButton.setImage(UIImage(systemName: "scissors"), for: .normal)
        cropButton.setImage(UIImage(systemName: "crop"), for: .normal)
        textButton.setImage(UIImage(systemName: "textformat"), for: .normal)
        
        // Use stack view for proper spacing
        let stack = UIStackView(arrangedSubviews: [trimButton, cropButton, textButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 40
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor)
        ])
        
        // Button actions
        trimButton.addTarget(self, action: #selector(didTapTrim), for: .touchUpInside)
        cropButton.addTarget(self, action: #selector(didTapCrop), for: .touchUpInside)
        textButton.addTarget(self, action: #selector(didTapText), for: .touchUpInside)
    }
    
    @objc private func didTapTrim() {
        let out = FileManager.default.temporaryDirectory.appendingPathComponent("story_trim.mp4")
        VideoEditService.trimVideo(inputURL: videoURL, outputURL: out, startTime: 0, duration: 10) { [weak self] ok, err in
            self?.handleResult(ok: ok, url: out, error: err)
        }
    }
    
    @objc private func didTapCrop() {
            // Calculate actual video dimensions
            let asset = AVAsset(url: videoURL)
            guard let track = asset.tracks(withMediaType: .video).first else { return }
            let transformedSize = track.naturalSize.applying(track.preferredTransform)
            let videoWidth = Int(abs(transformedSize.width))
            let videoHeight = Int(abs(transformedSize.height))
            let side = min(videoWidth, videoHeight)
            let x = (videoWidth - side) / 2
            let y = (videoHeight - side) / 2
            let output = FileManager.default.temporaryDirectory.appendingPathComponent("story_crop.mp4")
            VideoEditService.cropVideo(
                inputURL: videoURL,
                outputURL: output,
                width: side,
                height: side,
                x: x,
                y: y
            ) { [weak self] success, error in
                self?.handleResult(ok: success, url: output, error: error)
            }
        }
    
    @objc private func didTapText() {
        let out = FileManager.default.temporaryDirectory.appendingPathComponent("story_text.mp4")
        VideoEditService.addTextOverlay(
            inputURL: videoURL,
          outputURL: out,
          text: "Hello Story",
          fontFile: "/System/Library/Fonts/Helvetica.ttc",
          fontSize: 28,
          fontColor: "red",
          x: 20,
          y: 20
        ) { success, error in
            self.handleResult(ok: success, url: out, error: error)
        }
    }
    
    private func handleResult(ok: Bool, url: URL, error: Error?) {
        DispatchQueue.main.async {
            guard ok else { return self.showError(error) }
            self.playerVC?.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
            self.playerVC?.player?.play()
        }
    }
    
    private func showError(_ error: Error?) {
        let a = UIAlertController(title: "Lỗi", message: error?.localizedDescription, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}
