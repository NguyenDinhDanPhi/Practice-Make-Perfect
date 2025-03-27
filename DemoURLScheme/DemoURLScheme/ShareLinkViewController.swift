import UIKit

protocol ShareLinkViewControllerDelegate: AnyObject {
    func didCopyLink(success: Bool)
}

class ShareLinkViewController: UIViewController {
    private let shareLink: String
    weak var delegate: ShareLinkViewControllerDelegate?
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 68)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    init(shareLink: String) {
        self.shareLink = shareLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ShareLinkCollectionViewCell.self, forCellWithReuseIdentifier: ShareLinkCollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 68)
        ])
    }
    
    private func isAppInstalled(urlScheme: String) -> Bool {
        guard let url = URL(string: urlScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    private lazy var shareItems: [SocialNetworkSharing] = {
        let allItems: [SocialNetworkSharing] = [
            SocialNetworkSharing(icon: UIImage(named: "copyLink"), title: "Copy", action: copyLinkToClipboard),
            SocialNetworkSharing(icon: UIImage(named: "fb"), title: "Facebook", action: { self.shareToApp(urlScheme: "fb://composer?text=", webURL: "https://www.facebook.com/sharer/sharer.php?u=") }),
            SocialNetworkSharing(icon: UIImage(named: "mess"), title: "Messenger", action: { self.shareToApp(urlScheme: "fb-messenger://share?link=", webURL: "https://www.messenger.com/t/") }),
            SocialNetworkSharing(icon: UIImage(named: "tele"), title: "Telegram", action: { self.shareToApp(urlScheme: "tg://msg?text=", webURL: "https://t.me/share/url?url=") }),
            
            SocialNetworkSharing(icon: UIImage(named: "insta"), title: "Instagram", action: { self.shareToCopy(urlScheme: "instagram://")}),
            
            SocialNetworkSharing(icon: UIImage(named: "sms"), title: "SMS", action: { self.shareToCopy(urlScheme: "zalo://") }),
            SocialNetworkSharing(icon: UIImage(named: "ic_twitter"), title: "X", action: { self.shareToApp(urlScheme: "twitter://post?message=", webURL: "https://twitter.com/intent/tweet?text=") }),
            SocialNetworkSharing(icon: UIImage(named: "zalo"), title: "Zalo", action: {
                self.shareToCopy(urlScheme: "zalo://")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_whatapp"), title: "WhatsApp", action: {
                self.shareToApp(urlScheme: "whatsapp://send?text=", webURL: "https://api.whatsapp.com/send?text=")
            }),


            SocialNetworkSharing(icon: UIImage(named: "ic_more"), title: "More", action: openActivityView)
        ]
        return allItems.filter { $0.title == "Copy" || $0.title == "More" || isAppInstalled(urlScheme: urlScheme(for: $0.title)) }
    }()
    
    private func urlScheme(for app: String) -> String {
        switch app {
        case "Facebook": return "fb://"
        case "Messenger": return "fb-messenger://"
        case "Telegram": return "tg://"
        case "Instagram": return "instagram://"
        case "X": return "twitter://"
        case "WhatsApp": return "whatsapp://"
        case "Zalo": return "zalo://"

        default: return ""
        }
    }
    
    private func copyLinkToClipboard() {
        UIPasteboard.general.string = shareLink

        dismiss(animated: true) { [weak self] in
            self?.delegate?.didCopyLink(success: true)
        }
    }
    
    private func shareToCopy(urlScheme: String) {
        UIPasteboard.general.string = shareLink
        let appUrl = URL(string: "\(urlScheme)")
        if let appURL = appUrl, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
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
        print("haha")
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
          //  DispatchQueue.main.async {
                self.shareItems[indexPath.row].action()
           // }
        }
}
