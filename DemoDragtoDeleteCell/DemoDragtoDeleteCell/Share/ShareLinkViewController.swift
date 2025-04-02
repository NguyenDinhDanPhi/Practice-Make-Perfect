import UIKit

protocol ShareLinkViewControllerDelegate: AnyObject {
    func didCopyLink()
}

class ShareLinkViewController: UIViewController {
 
    

    struct LayoutMetrics {
        let itemSize: CGSize
        let minimumInteritemSpacing: CGFloat
        let minimumLineSpacing: CGFloat
        let collectionViewHeight: CGFloat
        let collectionViewPadding: CGFloat

        static let `default` = LayoutMetrics(
            itemSize: CGSize(width: 50, height: 68),
            minimumInteritemSpacing: 8,
            minimumLineSpacing: 8,
            collectionViewHeight: 68,
            collectionViewPadding: 20
        )
    }

    private let shareLink: String
    weak var delegate: ShareLinkViewControllerDelegate?
    var metrics: LayoutMetrics

    private var viewModel: ShareLinkViewModel!

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()

    private let grabber: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.layer.cornerRadius = 3
        return view
    }()

    private let dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(dismissSheet), for: .touchUpInside)
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = metrics.itemSize
        layout.minimumInteritemSpacing = metrics.minimumInteritemSpacing
        layout.minimumLineSpacing = metrics.minimumLineSpacing

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    init(shareLink: String) {
        self.shareLink = shareLink
        self.metrics = LayoutMetrics.default
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupBottomSheetUI()
        setupCollectionView()
        setupDismissButton()
        viewModel = ShareLinkViewModel(shareLink: shareLink, delegate: delegate, presentingVC: self)

    }

    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
    }

    private func setupBottomSheetUI() {
        view.addSubview(containerView)

        let height = metrics.collectionViewHeight + 60

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: height)
        ])

        containerView.addSubview(grabber)
        grabber.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            grabber.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            grabber.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            grabber.widthAnchor.constraint(equalToConstant: 40),
            grabber.heightAnchor.constraint(equalToConstant: 5)
        ])
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShareLinkCollectionViewCell.self, forCellWithReuseIdentifier: ShareLinkCollectionViewCell.identifier)

        containerView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: metrics.collectionViewPadding),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -metrics.collectionViewPadding),
            collectionView.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 16),
            collectionView.heightAnchor.constraint(equalToConstant: metrics.collectionViewHeight)
        ])
    }

    private func setupDismissButton() {
        view.addSubview(dismissButton)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }

    @objc private func dismissSheet() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ShareLinkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.shareItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareLinkCollectionViewCell.identifier, for: indexPath) as! ShareLinkCollectionViewCell
        cell.configure(with: viewModel.shareItems[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.shareItems[indexPath.row].action()
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Delegate
//extension ShareLinkViewController: ShareLinkViewControllerDelegate {
//    func didCopyLink() {
//        // You can show toast/snackbar or any feedback here
//        print("Link copied!")
//    }
//}
