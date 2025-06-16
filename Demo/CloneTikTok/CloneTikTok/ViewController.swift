import UIKit

// MARK: - Main View Controller
class ViewController: UIViewController {

    private let tabs = HomeTab.allCases
    private let header = TabHeaderView()
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupHeader()
        setupCollectionView()
    }

    private func setupHeader() {
 
        header.onTabSelected = { [weak self] index in
            self?.scrollToPage(index)
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        // itemSize sẽ đặt trong viewDidLayoutSubviews đảm bảo đúng kích thước hiện tại

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "PageCell")

        view.addSubview(collectionView)
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            header.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50),
            header.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Cập nhật itemSize khi view thay đổi (rotation, safe area, ...)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let size = collectionView.bounds.size
            if layout.itemSize != size {
                layout.itemSize = size
                layout.invalidateLayout()
                // Khi rotate, giữ page hiện tại ở viewport
                let index = header.selectedIndex
                let offsetX = CGFloat(index) * size.width
                collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
            }
        }
    }

    private func scrollToPage(_ index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageCell", for: indexPath) as! PageCell
        let tab = tabs[indexPath.item]
        cell.configure(for: tab, parentVC: self)
        return cell
    }

    // Kích thước được set trong viewDidLayoutSubviews, có thể vẫn implement:
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Cập nhật underline khi swipe
        header.updateUnderlinePosition(scrollOffsetX: scrollView.contentOffset.x, scrollViewWidth: scrollView.bounds.width)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        header.selectedIndex = index
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        header.selectedIndex = index
    }
}
