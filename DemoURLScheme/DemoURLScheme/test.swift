////
////  test.swift
////  DemoURLScheme
////
////  Created by dan phi on 26/3/25.
////
//
//import UIKit
//
//class HomeViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        let openShareButton = UIButton(type: .system)
//        openShareButton.setTitle("Mở Share View", for: .normal)
//        openShareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        openShareButton.backgroundColor = .systemBlue
//        openShareButton.setTitleColor(.white, for: .normal)
//        openShareButton.layer.cornerRadius = 10
//        openShareButton.frame = CGRect(x: 50, y: 200, width: 250, height: 50)
//        openShareButton.addTarget(self, action: #selector(openShareView), for: .touchUpInside)
//        
//        view.addSubview(openShareButton)
//    }
//    
//    @objc func openShareView() {
//        let shareVC = ShareLinkViewController(shareLink: "https://apps.apple.com/app/id6470351765")
//        
//        if let sheet = shareVC.sheetPresentationController {
//            if #available(iOS 16.0, *) {
//                let customDetent = UISheetPresentationController.Detent.custom { _ in
//                    return 161
//                }
//                
//                sheet.detents = [customDetent]
//            }
//            sheet.prefersGrabberVisible = true
//        }
//        
//        present(shareVC, animated: true)
//    }
//
//       
//    
//}
