//
//  VideoPlayerCell.swift
//  UpLoad and Edit video
//
//  Created by Dan Phi on 30/7/25.
//
import UIKit
import AVFoundation

class VideoPlayerCell: UICollectionViewCell {
    static let reuseIdentifier = "VideoPlayerCell"

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with video: Video) {
        // Remove cũ nếu có
        playerLayer?.removeFromSuperlayer()
        player?.pause()

        // Tạo mới
        player = AVPlayer(url: video.url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = contentView.bounds
        if let pl = playerLayer {
            contentView.layer.addSublayer(pl)
        }

        // Lặp lại
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main) { [weak self] _ in
                self?.player?.seek(to: .zero)
                self?.player?.play()
        }
    }

    func play() {
        player?.play()
    }

    func pause() {
        player?.pause()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
}
