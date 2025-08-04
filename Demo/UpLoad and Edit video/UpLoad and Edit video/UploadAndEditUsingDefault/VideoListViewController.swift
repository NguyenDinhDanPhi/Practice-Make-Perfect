import UIKit

class VideoListViewController: UIViewController {

    private var videos: [Video] = []
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      videos = VideoManager.shared.fetchVideos()
      collectionView.reloadData()
      DispatchQueue.main.async { self.playVisibleCell() }
    }


    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.itemSize = view.bounds.size

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(VideoPlayerCell.self,
                                forCellWithReuseIdentifier: VideoPlayerCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate   = self

        view.addSubview(collectionView)
    }

    // Tìm ô hiển thị giữa màn hình và play
    private func playVisibleCell() {
        for cell in collectionView.visibleCells {
            if let videoCell = cell as? VideoPlayerCell {
                let cellRect = collectionView.convert(videoCell.frame, to: view)
                // Ô nào chiếm >=50% màn hình sẽ được play
                if cellRect.intersects(view.bounds) {
                    videoCell.play()
                } else {
                    videoCell.pause()
                }
            }
        }
    }
}

extension VideoListViewController: UICollectionViewDataSource {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }

    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: VideoPlayerCell.reuseIdentifier,
                                          for: indexPath) as! VideoPlayerCell
        cell.configure(with: videos[indexPath.item])
        return cell
    }
}

extension VideoListViewController: UICollectionViewDelegate {
    // Khi một cell sắp được hiển thị → play
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoPlayerCell else { return }
        videoCell.play()
    }

    // Khi một cell vừa bị cuốn ra ngoài màn hình → pause
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let videoCell = cell as? VideoPlayerCell else { return }
        videoCell.pause()
    }

    // Giữ nguyên để play cell “chính” sau khi user scroll xong
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        playVisibleCell()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        if !decelerate {
            playVisibleCell()
        }
    }
}
