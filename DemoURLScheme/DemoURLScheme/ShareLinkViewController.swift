import UIKit
import Photos

class ShareLinkViewController: UIViewController {
    
    private let shareLink: String
    
    init(shareLink: String) {
        self.shareLink = shareLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Hàm kiểm tra ứng dụng có được cài đặt không
    private func isAppInstalled(urlScheme: String) -> Bool {
        if let url = URL(string: urlScheme) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    // Danh sách tất cả các ứng dụng
    private lazy var allShareItems: [SocialNetworkSharing] = [
        SocialNetworkSharing(icon: UIImage(named: "copyLink"), title: "Copy", action: copyLinkToClipboard),
        SocialNetworkSharing(icon: UIImage(named: "fb"), title: "Facebook", action: openFacebook),
        SocialNetworkSharing(icon: UIImage(named: "mess"), title: "Messenger", action: shareToMessenger),
        SocialNetworkSharing(icon: UIImage(named: "tele"), title: "Telegram", action: openTelegram),
        SocialNetworkSharing(icon: UIImage(named: "insta"), title: "Instagram", action: shareToInstagram),
        SocialNetworkSharing(icon: UIImage(named: "sms"), title: "SMS", action: shareToSMS),
        SocialNetworkSharing(icon: UIImage(systemName: "hehe"), title: "X", action: shareToTwitter),
        SocialNetworkSharing(icon: UIImage(systemName: "more"), title: "More", action: openActivityView)
        
        
    ]
    
    // Lọc chỉ giữ lại những ứng dụng đã cài đặt
    private lazy var shareItems: [SocialNetworkSharing] = {
        return allShareItems.filter { item in
            switch item.title {
            case "Facebook":
                return isAppInstalled(urlScheme: "fb://")
            case "Messenger":
                return isAppInstalled(urlScheme: "fb-messenger://")
            case "Telegram":
                return isAppInstalled(urlScheme: "tg://")
            case "Instagram":
                return isAppInstalled(urlScheme: "instagram://")
            case "X":
                return isAppInstalled(urlScheme: "twitter://")
            default:
                return true // Copy luôn hiển thị
            }
        }
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 68)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        collectionView.reloadData()
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
        shareItems[indexPath.row].action()
        //        DispatchQueue.main.async {
        //                    self.dismiss(animated: true)
        //        }
    }
}

// MARK: - Share Actions
extension ShareLinkViewController {
    private func openApp(urlScheme: String, webURL: String?) {
        let shareURL = shareLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let appURLString = "\(urlScheme)\(shareURL)"
        
        if let appURL = URL(string: appURLString), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = webURL, let fallbackURL = URL(string: "\(webURL)\(shareURL)") {
            UIApplication.shared.open(fallbackURL)
        }
    }
    
    private func openFacebook() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.openApp(urlScheme: "fb://composer?text=", webURL: "https://www.facebook.com/sharer/sharer.php?u=")
        }
    }
    
    private func openTelegram() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.openApp(urlScheme: "tg://msg?text=", webURL: "https://t.me/share/url?url=")
        }
    }
    
    private func shareToMessenger() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.openApp(urlScheme: "fb-messenger://share?link=", webURL: "https://www.messenger.com/t/")
        }
    }
    
    private func shareToInstagram() {
        self.dismiss(animated: true) { [weak self] in
                guard let self else { return }
            self.openApp(urlScheme: "instagram://story-camera", webURL: "https://www.instagram.com/")
        }
    }
    
    private func copyLinkToClipboard() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            UIPasteboard.general.string = shareLink
            let alert = UIAlertController(title: "Đã sao chép", message: "Link đã được sao chép vào clipboard!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    @objc func shareToSMS() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            openApp(urlScheme: "sms:?&body=", webURL: nil)
        }
    }
    @objc func shareToTwitter() {
        self.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            openApp(urlScheme: "twitter://post?message=", webURL: "https://twitter.com/intent/tweet?text=")
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
