//
//  ShareLinkViewModel.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 2/4/25.
//

import UIKit

struct SocialNetworkSharing {
    let icon: UIImage?
    let title: String
    let action: () -> Void
}

final class ShareLinkViewModel {

    private let shareLink: String
    weak var delegate: ShareLinkViewControllerDelegate?
    weak var presentingViewController: UIViewController?

    init(shareLink: String, delegate: ShareLinkViewControllerDelegate?, presentingVC: UIViewController?) {
        self.shareLink = shareLink
        self.delegate = delegate
        self.presentingViewController = presentingVC
    }

    lazy var shareItems: [SocialNetworkSharing] = {
        let items: [SocialNetworkSharing] = [
            SocialNetworkSharing(icon: UIImage(named: "ic_copyLink"), title: "Copy", action: copyLinkToClipboard),
            SocialNetworkSharing(icon: UIImage(named: "ic_fb"), title: "Facebook", action: { [weak self] in
                self?.shareToApp(urlScheme: "fb://composer?text=", webURL: "https://www.facebook.com/sharer/sharer.php?u=")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_messenger"), title: "Messenger", action: { [weak self] in
                self?.shareToApp(urlScheme: "fb-messenger://share?link=", webURL: "https://www.messenger.com/t/")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_telegram"), title: "Telegram", action: { [weak self] in
                self?.shareToApp(urlScheme: "tg://msg?text=", webURL: "https://t.me/share/url?url=")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_sms"), title: "SMS", action: { [weak self] in
                self?.shareToApp(urlScheme: "sms:?&body=", webURL: nil)
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_twitter"), title: "X", action: { [weak self] in
                self?.shareToApp(urlScheme: "twitter://post?message=", webURL: "https://twitter.com/intent/tweet?text=")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_whatapp"), title: "WhatsApp", action: { [weak self] in
                self?.shareToApp(urlScheme: "whatsapp://send?text=", webURL: "https://api.whatsapp.com/send?text=")
            }),
            SocialNetworkSharing(icon: UIImage(named: "ic_more"), title: "More", action: { [weak self] in
                self?.openActivityView()
            })
        ]
        return items.filter {
            $0.title == "Copy" || $0.title == "More" || $0.title == "SMS" || isAppInstalled(urlScheme: urlScheme(for: $0.title))
        }
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
        delegate?.didCopyLink()
    }

    private func shareToApp(urlScheme: String, webURL: String?) {
        let encodedLink = shareLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let appURL = URL(string: "\(urlScheme)\(encodedLink)")
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

        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = presentingVC.view
            popoverController.sourceRect = CGRect(x: presentingVC.view.bounds.midX, y: presentingVC.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        presentingVC.present(activityVC, animated: true)
    }
}
