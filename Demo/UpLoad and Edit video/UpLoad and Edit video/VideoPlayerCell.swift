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
    private var timeObserver: Any?

    // UI Controls
    private let playPauseButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let progressSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 1
        return slider
    }()
    private let timeLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .monospacedDigitSystemFont(ofSize: 12, weight: .medium)
        lbl.textColor = .white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "00:00 / 00:00"
        return lbl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        setupControls()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func setupControls() {
        contentView.addSubview(playPauseButton)
        contentView.addSubview(progressSlider)
        contentView.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            playPauseButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            playPauseButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),
            playPauseButton.widthAnchor.constraint(equalToConstant: 24),
            playPauseButton.heightAnchor.constraint(equalToConstant: 24),

            progressSlider.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 8),
            progressSlider.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            progressSlider.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),

            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeLabel.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor)
        ])

        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(didChangeSlider), for: .valueChanged)
    }

    func configure(with video: Video) {
        // Clean up old
        prepareForReuse()

        // Setup player
        player = AVPlayer(url: video.url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = .resizeAspect
        playerLayer!.frame = contentView.bounds
        contentView.layer.insertSublayer(playerLayer!, at: 0)

        // Observe time to update slider & label
        let interval = CMTime(seconds: 0.1, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self,
                  let duration = self.player?.currentItem?.duration.seconds,
                  duration > 0 else { return }
            let current = time.seconds
            self.progressSlider.value = Float(current / duration)
            self.timeLabel.text = "\(self.formatTime(current)) / \(self.formatTime(duration))"
        }
        
        player?.play()
        playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        // Sau khi player.play() ở cuối configure(...)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidReachEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem
        )

    }
    
    @objc private func playerDidReachEnd(_ notification: Notification) {
        player?.seek(to: .zero)        // quay về đầu
        player?.play()                 // chơi lại
        playPauseButton.setImage(
          UIImage(systemName: "pause.fill"),
          for: .normal
        )
    }


    @objc private func didTapPlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .playing {
            player.pause()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    @objc private func didChangeSlider() {
        guard let duration = player?.currentItem?.duration.seconds, duration > 0 else { return }
        let newTime = CMTime(seconds: Double(progressSlider.value) * duration, preferredTimescale: 600)
        player?.seek(to: newTime)
    }

    private func formatTime(_ secs: Double) -> String {
        let t = Int(secs)
        let m = t / 60
        let s = t % 60
        return String(format: "%02d:%02d", m, s)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // Remove observer
        if let obs = timeObserver { player?.removeTimeObserver(obs); timeObserver = nil }
        // Stop and cleanup
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        NotificationCenter.default.removeObserver( self, name: .AVPlayerItemDidPlayToEndTime, object: nil )
    }
}
// MARK: – Playback control
extension VideoPlayerCell {
  func play() {
    player?.play()
    playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
  }

  func pause() {
    player?.pause()
    playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
  }
}
