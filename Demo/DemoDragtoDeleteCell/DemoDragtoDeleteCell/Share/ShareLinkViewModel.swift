import UIKit



final class ShareLinkViewModel {

    private let shareLink: String
    weak var delegate: ShareLinkViewControllerDelegate?
    weak var presentingViewController: UIViewController?

    init(shareLink: String, delegate: ShareLinkViewControllerDelegate?, presentingVC: UIViewController?) {
        self.shareLink = shareLink
        self.delegate = delegate
        self.presentingViewController = presentingVC
    }

    lazy var shareItems: [SocialNetworkSharingModel] = {
        return SocialPlatform.allCases.compactMap { platform in
            if platform.requiresAppInstalled,
               let scheme = platform.urlScheme,
               !isAppInstalled(urlScheme: scheme) {
                return nil
            }

            let icon = UIImage(named: platform.iconName)
            let title = platform.title

            let action: () -> Void = { [weak self] in
                guard let self = self else { return }

                switch platform {
                case .copy:
                    self.copyLinkToClipboard()
                case .more:
                    self.openActivityView()
                default:
                    self.shareToApp(urlScheme: platform.urlScheme, webURL: platform.webURL)
                }
            }

            return SocialNetworkSharingModel(icon: icon, title: title, action: action)
        }
    }()

    private func isAppInstalled(urlScheme: String) -> Bool {
        guard let url = URL(string: urlScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    private func copyLinkToClipboard() {
        UIPasteboard.general.string = shareLink
        delegate?.didCopyLink()
    }

    private func shareToApp(urlScheme: String?, webURL: String?) {
        let encodedLink = shareLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let scheme = urlScheme else { return }
        let appURL = URL(string: "\(scheme)\(encodedLink)")
        let fallbackURL = webURL.flatMap { URL(string: "\($0)\(encodedLink)") }

        if let appURL = appURL, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let fallbackURL = fallbackURL {
            UIApplication.shared.open(fallbackURL)
        }
    }

    private func openActivityView() {
        guard let presentingVC = presentingViewController else { return }

        let activityVC = UIActivityViewController(activityItems: [URL(string: shareLink) ?? shareLink], applicationActivities: nil)

        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = presentingVC.view
            popover.sourceRect = CGRect(x: presentingVC.view.bounds.midX, y: presentingVC.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        presentingVC.present(activityVC, animated: true)
    }
}
