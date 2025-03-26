//
//  HomViewController.swift
//  DemoURLScheme
//
//  Created by dan phi on 25/3/25.
//

import UIKit

class HomeViewController: UIViewController {
    var link = "https://www.tiktok.com/@pbm2025365/video/7459553572993174830?is_from_webapp=1&sender_device=pc"
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
        let shareVC = ShareLinkViewController(shareLink: link)
        if let sheet = shareVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return 161
            }
            
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }
        present(shareVC, animated: true)
    }
}
