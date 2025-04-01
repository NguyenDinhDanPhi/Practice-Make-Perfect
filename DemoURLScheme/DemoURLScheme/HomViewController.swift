//
//  HomViewController.swift
//  DemoURLScheme
//
//  Created by dan phi on 25/3/25.
//

import UIKit

class HomeViewController: UIViewController, ShareLinkViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let openShareButton = UIButton(type: .system)
        openShareButton.setTitle("Mở Share View", for: .normal)
        openShareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        openShareButton.backgroundColor = .systemBlue
        openShareButton.setTitleColor(.white, for: .normal)
        openShareButton.layer.cornerRadius = 10
        openShareButton.frame = CGRect(x: 50, y: 200, width: 250, height: 50)
        openShareButton.addTarget(self, action: #selector(openShareView), for: .touchUpInside)
        
        view.addSubview(openShareButton)
    }
    
    @objc func openShareView() {
        let link = "https://www.google.com/"
        let shareVC = ShareLinkViewController(shareLink: link)
        shareVC.delegate = self
        if let sheet = shareVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return 161
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }
        present(shareVC, animated: true)
    }

    func didCopyLink() {
                let alert = UIAlertController(title: "Đã sao chép", message: "Link đã được sao chép vào clipboard!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
        
    }
}

