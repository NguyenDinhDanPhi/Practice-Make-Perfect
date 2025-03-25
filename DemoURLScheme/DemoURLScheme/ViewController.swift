//
//  ViewController.swift
//  DemoURLScheme
//
//  Created by dan phi on 25/3/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Tạo button để mở ứng dụng ngoài
        let openAppButton = UIButton(type: .system)
        openAppButton.setTitle("Mở Facebook", for: .normal)
        openAppButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        openAppButton.backgroundColor = .lightGray
        openAppButton.setTitleColor(.blue, for: .normal)
        openAppButton.layer.cornerRadius = 10
        openAppButton.frame = CGRect(x: 50, y: 150, width: 250, height: 50)
        openAppButton.addTarget(self, action: #selector(openFacebook), for: .touchUpInside)
        
        let openZaloButton = UIButton(type: .system)
        openZaloButton.setTitle("Mở Zalo", for: .normal)
        openZaloButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        openZaloButton.backgroundColor = .lightGray
        openZaloButton.setTitleColor(.blue, for: .normal)
        openZaloButton.layer.cornerRadius = 10
        openZaloButton.frame = CGRect(x: 50, y: 220, width: 250, height: 50)
        openZaloButton.addTarget(self, action: #selector(openZalo), for: .touchUpInside)
        
        let openMessengerButton = UIButton(type: .system)
        openMessengerButton.setTitle("Mở Messenger", for: .normal)
        openMessengerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        openMessengerButton.backgroundColor = .lightGray
        openMessengerButton.setTitleColor(.blue, for: .normal)
        openMessengerButton.layer.cornerRadius = 10
        openMessengerButton.frame = CGRect(x: 50, y: 290, width: 250, height: 50)
        openMessengerButton.addTarget(self, action: #selector(shareToMessenger), for: .touchUpInside)
        
        let openSMS = UIButton(type: .system)
        openSMS.setTitle("Mở SMS", for: .normal)
        openSMS.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        openSMS.backgroundColor = .lightGray
        openSMS.setTitleColor(.blue, for: .normal)
        openSMS.layer.cornerRadius = 10
        openSMS.frame = CGRect(x: 50, y: 360, width: 250, height: 50)
        openSMS.addTarget(self, action: #selector(shareToSMS), for: .touchUpInside)
        
        let openTwitter = UIButton(type: .system)
        openTwitter.setTitle("Mở Twitter", for: .normal)
        openTwitter.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        openTwitter.backgroundColor = .lightGray
        openTwitter.setTitleColor(.blue, for: .normal)
        openTwitter.layer.cornerRadius = 10
        openTwitter.frame = CGRect(x: 50, y: 430, width: 250, height: 50)
        openTwitter.addTarget(self, action: #selector(shareToTwitter), for: .touchUpInside)
        
        let openInsta = UIButton(type: .system)
        openInsta.setTitle("Mở insta", for: .normal)
        openInsta.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        openInsta.backgroundColor = .lightGray
        openInsta.setTitleColor(.blue, for: .normal)
        openInsta.layer.cornerRadius = 10
        openInsta.frame = CGRect(x: 50, y: 500, width: 250, height: 50)
        openInsta.addTarget(self, action: #selector(shareToInstagram), for: .touchUpInside)
        
        let copyLinkButton = UIButton(type: .system)
        copyLinkButton.setTitle("Copy Link", for: .normal)
        copyLinkButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        copyLinkButton.backgroundColor = .white
        copyLinkButton.setTitleColor(.blue, for: .normal)
        copyLinkButton.layer.cornerRadius = 10
        copyLinkButton.frame = CGRect(x: 50, y: 570, width: 250, height: 50)
        copyLinkButton.addTarget(self, action: #selector(copyLinkToClipboard), for: .touchUpInside)

        view.addSubview(copyLinkButton)
        view.addSubview(openInsta)
        view.addSubview(openTwitter)
        view.addSubview(openSMS)
        view.addSubview(openMessengerButton)
        view.addSubview(openZaloButton)
        view.addSubview(openAppButton)
    }
    
    // Hàm mở ứng dụng Facebook bằng URL Scheme
    @objc func openFacebook() {
        let shareURL = "https://yourwebsite.com"
        let fbURLString = "fb://facewebmodal/f?href=\(shareURL)"
        
        if let fbURL = URL(string: fbURLString), UIApplication.shared.canOpenURL(fbURL) {
            UIApplication.shared.open(fbURL)
        } else if let webURL = URL(string: "https://www.facebook.com/sharer/sharer.php?u=\(shareURL)") {
            UIApplication.shared.open(webURL)
        }
    }
    @objc func openZalo() {
        let shareURL = "https://yourwebsite.com"
        let encodedURL = shareURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let zaloURLString = "zalo://send?text=\(encodedURL)"
        
        if let zaloURL = URL(string: zaloURLString), UIApplication.shared.canOpenURL(zaloURL) {
            UIApplication.shared.open(zaloURL)
        } else if let webURL = URL(string: "https://zalo.me/share?url=\(encodedURL)") {
            UIApplication.shared.open(webURL)
        }
        
    }
    @objc func shareToMessenger() {
        let shareURL = "https://yourwebsite.com"
        let encodedURL = shareURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let messengerURLString = "fb-messenger://share?link=\(encodedURL)"

        if let messengerURL = URL(string: messengerURLString), UIApplication.shared.canOpenURL(messengerURL) {
            UIApplication.shared.open(messengerURL)
        } else if let webURL = URL(string: "https://www.messenger.com/t/") {
            UIApplication.shared.open(webURL)
        }
    }
    @objc func shareToSMS() {
        let shareURL = "https://yourwebsite.com"
        let message = "Xem link này nhé: \(shareURL)"
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let smsURLString = "sms:?&body=\(encodedMessage)"

        if let smsURL = URL(string: smsURLString), UIApplication.shared.canOpenURL(smsURL) {
            UIApplication.shared.open(smsURL)
        } else {
            print("Không thể mở SMS")
        }
    }
    @objc func shareToTwitter() {
        let shareURL = "https://yourwebsite.com"
        let tweetText = "Hãy xem bài viết này: \(shareURL)"
        let encodedText = tweetText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let twitterURLString = "twitter://post?message=\(encodedText)"

        if let twitterURL = URL(string: twitterURLString), UIApplication.shared.canOpenURL(twitterURL) {
            UIApplication.shared.open(twitterURL)
        } else if let webURL = URL(string: "https://twitter.com/intent/tweet?text=\(encodedText)") {
            UIApplication.shared.open(webURL)
        }
    }
    @objc func shareToInstagram() {
        let shareURL = "https://yourwebsite.com"
        let instagramURLString = "instagram://story-camera"

        if let instagramURL = URL(string: instagramURLString), UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL)
        } else {
            UIApplication.shared.open(URL(string: "https://www.instagram.com/")!)
        }
    }
    @objc func copyLinkToClipboard() {
        let shareURL = "https://yourwebsite.com"
        UIPasteboard.general.string = shareURL

        // Hiển thị thông báo khi copy thành công
        let alert = UIAlertController(title: "Đã sao chép", message: "Link đã được sao chép vào clipboard!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }


    

}
