//
//  EditViewController.swift
//  FFmpegDemo
//
//  Created by Dan Phi on 6/8/25.
//

import UIKit
import AVKit
import AVFoundation

class EditViewController: UIViewController {
    private var currentURL: URL
    private var playerVC: AVPlayerViewController?
    
    private let trimButton = UIButton(type: .system)
    private let cropButton = UIButton(type: .system)
    private let textButton = UIButton(type: .system)
    
    init(videoURL: URL) {
        self.currentURL = videoURL
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
        let player = AVPlayer(url: currentURL)
        let vc = AVPlayerViewController()
        vc.player = player
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
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
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40)
        ])
        
        trimButton.addTarget(self, action: #selector(didTapTrim), for: .touchUpInside)
        cropButton.addTarget(self, action: #selector(didTapCrop), for: .touchUpInside)
        textButton.addTarget(self, action: #selector(didTapText), for: .touchUpInside)
    }
    
    @objc private func didTapTrim() {
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_trim_\(Date().timeIntervalSince1970).mp4")
        
        VideoEditService.trimVideo(
            inputURL: currentURL,
            outputURL: out,
            startTime: 0,
            duration: 10
        ) { [weak self] success, error in
            guard success else {
                 self?.showError(error)
                return
            }
            self?.currentURL = out
            self?.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapCrop() {
        let asset = AVAsset(url: currentURL)
        guard let track = asset.tracks(withMediaType: .video).first else { return }
        let transformedSize = track.naturalSize.applying(track.preferredTransform)
        let videoWidth = Int(abs(transformedSize.width))
        let videoHeight = Int(abs(transformedSize.height))
        let side = min(videoWidth, videoHeight)
        let x = (videoWidth - side) / 2
        let y = (videoHeight - side) / 2
        
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_crop_\(Date().timeIntervalSince1970).mp4")
        
        VideoEditService.cropVideo(
            inputURL: currentURL,
            outputURL: out,
            width: side,
            height: side,
            x: x,
            y: y
        ) { [weak self] success, error in
            guard let self = self, success else {
                self?.showError(error)
                return
            }
            self.currentURL = out
            self.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapText() {
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_text_\(Date().timeIntervalSince1970).mp4")
        
        VideoEditService.addTextOverlay(
            inputURL: currentURL,
            outputURL: out,
            text: "Hello Story",
            fontFile: "/System/Library/Fonts/Helvetica.ttc",
            fontSize: 28,
            fontColor: "red",
            x: 20,
            y: 20
        ) { [weak self] success, error in
            guard let self = self, success else {
                self?.showError(error)
                return
            }
            self.currentURL = out
            self.replacePlayerItem(with: out)
        }
    }
    
    private func replacePlayerItem(with url: URL) {
        DispatchQueue.main.async {
            let newItem = AVPlayerItem(url: url)
            self.playerVC?.player?.replaceCurrentItem(with: newItem)
            self.playerVC?.player?.play()
        }
    }
    
    private func showError(_ error: Error?) {
        let alert = UIAlertController(
            title: "Lỗi",
            message: error?.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
