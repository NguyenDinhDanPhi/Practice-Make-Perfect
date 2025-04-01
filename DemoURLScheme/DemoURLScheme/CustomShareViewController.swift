//
//  ViewController.swift
//  DemoURLScheme
//
//  Created by dan phi on 25/3/25.
//

import UIKit

class CustomShareViewController: UIViewController {
    private var shareLink: String
    init(shareLink: String) {
        self.shareLink = shareLink
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        let buttons = [
            createButton(title: "Mở Facebook", action: #selector(openFacebook)),
            createButton(title: "Mở Zalo", action: #selector(openZalo)),
            createButton(title: "Mở Messenger", action: #selector(shareToMessenger)),
            createButton(title: "Mở SMS", action: #selector(shareToSMS)),
            createButton(title: "Mở Twitter", action: #selector(shareToTwitter)),
            createButton(title: "Mở Instagram", action: #selector(shareToInstagram)),
            createButton(title: "Copy Link", action: #selector(copyLinkToClipboard))
        ]
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .lightGray
        button.setTitleColor(.blue, for: .normal)
        button.layer.cornerRadius = 10
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    @objc func openFacebook() {
        openApp(urlScheme: "fb://composer?text=", webURL: "https://www.facebook.com/sharer/sharer.php?u=")
    }
    
    @objc func openZalo() {
        openApp(urlScheme: "zalo://send?text=", webURL: "https://zalo.me/share?url=")
    }
    @objc func shareToMessenger() { openApp(urlScheme: "fb-messenger://share?link=", webURL: "https://www.messenger.com/t/") }
    @objc func shareToSMS() { openApp(urlScheme: "sms:?&body=", webURL: nil) }
    @objc func shareToTwitter() { openApp(urlScheme: "twitter://post?message=", webURL: "https://twitter.com/intent/tweet?text=") }
    @objc func shareToInstagram() { openApp(urlScheme: "instagram://story-camera", webURL: "https://www.instagram.com/") }
    
    private func openApp(urlScheme: String, webURL: String?) {
        let shareURL = shareLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let appURLString = "\(urlScheme)\(shareURL)"
        
        if let appURL = URL(string: appURLString), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = webURL, let fallbackURL = URL(string: "\(webURL)\(shareURL)") {
            UIApplication.shared.open(fallbackURL)
        }
    }
    
    @objc func copyLinkToClipboard() {
        UIPasteboard.general.string = shareLink
        let alert = UIAlertController(title: "Đã sao chép", message: "Link đã được sao chép vào clipboard!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
