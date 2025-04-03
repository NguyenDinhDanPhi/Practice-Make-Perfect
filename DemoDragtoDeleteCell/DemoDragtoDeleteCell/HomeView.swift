//
//  HomeView.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 2/4/25.
//

import UIKit

class HomeView: UIViewController, ShareLinkViewControllerDelegate {
    func handleDismiss() {
       // dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)

    }
    
    func didCopyLink() {
        print("hehe")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Tạo nút bấm mở BottomSheet
        let button = UIButton(type: .system)
        button.setTitle("Mở Bottom Sheet", for: .normal)
        button.addTarget(self, action: #selector(openBottomSheet), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func openBottomSheet() {
        let bottomSheet = ShareLinkViewController(shareLink: "link muốn share")
        bottomSheet.delegate = self
        navigationController?.pushViewController(bottomSheet, animated: true)

    }
}
