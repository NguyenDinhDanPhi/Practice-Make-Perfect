//
//  ShareLinkViewController.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 2/4/25.
//

//
//  ShareLinkViewController.swift
//  Streaming
//
//  Created by dan phi on 26/3/25.
//

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

    private let containerView = UIView()
    private let grabber = UIView()

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
    }

    private func setupBackground() {
     view.backgroundColor = UIColor.black.withAlphaComponent(0.3)

//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
//        view.addGestureRecognizer(tap)
    }

    @objc private func dismissSheet() {
        dismiss(animated: true, completion: nil)
    }

    private func setupBottomSheetUI() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let height = metrics.collectionViewHeight + 60

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: height)
        ])

        grabber.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        grabber.layer.cornerRadius = 3
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

    private lazy var shareItems: [SocialNetworkSharing] = {
        let allItems: [SocialNetworkSharing] = [
            SocialNetworkSharing(icon: UIImage(named: "ic_copyLink"), title: "Copy", action: copyLinkToClipboard),
            SocialNetworkSharing(icon: UIImage(named: "ic_fb"), title: "Facebook", action: { [weak self] in
                guard let self = self else { return }
                self.shareToApp(urlScheme: "fb://composer?text=", webURL: "https://www.facebook.com/sharer/sharer.php?u=") }),
            SocialNetworkSharing(icon: UIImage(named: "ic_messenger"), title: "Messenger", action: { [weak self] in
                guard let self = self else { return }
                self.shareToApp(urlScheme: "fb-messenger://share?link=", webURL: "https://www.messenger.com/t/")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_telegram"), title: "Telegram", action: { [weak self] in
                guard let self = self else { return }
                self.shareToApp(urlScheme: "tg://msg?text=", webURL: "https://t.me/share/url?url=")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_sms"), title: "SMS", action: { [weak self] in
                guard let self = self else { return }
                self.shareToApp(urlScheme: "sms:?&body=", webURL: nil)
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_twitter"), title: "X", action: { [weak self] in
                guard let self = self else { return }
                self.shareToApp(urlScheme: "twitter://post?message=", webURL: "https://twitter.com/intent/tweet?text=")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_whatapp"), title: "WhatsApp", action: { [weak self] in
                guard let self = self else { return }
                self.shareToApp(urlScheme: "whatsapp://send?text=", webURL: "https://api.whatsapp.com/send?text=")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_more"), title: "More", action: openActivityView)
        ]
        return allItems.filter { $0.title == "Copy" || $0.title == "More" || $0.title == "SMS" || isAppInstalled(urlScheme: urlScheme(for: $0.title)) }
    }()

    private func isAppInstalled(urlScheme: String) -> Bool {
        guard let url = URL(string: urlScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    private func urlScheme(for app: String) -> String {
        switch app {
        case "Facebook": return "fb://"
        case "Messenger": return "fb-messenger://"
        case "Telegram": return "tg://"
        case "X": return "twitter://"
        case "WhatsApp": return "whatsapp://"
        default: return ""
        }
    }

    private func copyLinkToClipboard() {
        UIPasteboard.general.string = shareLink
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didCopyLink()
        }
    }

    @objc private func shareToApp(urlScheme: String, webURL: String?) {
        let encodedLink = shareLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let appURL = URL(string: "\(urlScheme)\(encodedLink)")
        let fallbackURL = webURL.flatMap { URL(string: "\($0)\(encodedLink)") }
        dismiss(animated: true) {
            if let appURL = appURL, UIApplication.shared.canOpenURL(appURL) {
                UIApplication.shared.open(appURL)
            } else if let fallbackURL = fallbackURL {
                UIApplication.shared.open(fallbackURL)
            }
        }
    }

    private func openActivityView() {
        guard let presentingVC = self.presentingViewController else { return }

        self.dismiss(animated: true) {
            let activityVC = UIActivityViewController(activityItems: [URL(string: self.shareLink) ?? self.shareLink], applicationActivities: nil)

            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = presentingVC.view
                popoverController.sourceRect = CGRect(x: presentingVC.view.bounds.midX, y: presentingVC.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }

            presentingVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - UICollectionView Delegate & DataSource
extension ShareLinkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shareItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShareLinkCollectionViewCell.identifier, for: indexPath) as! ShareLinkCollectionViewCell
        cell.configure(with: shareItems[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.shareItems[indexPath.row].action()
        }
    }
}
