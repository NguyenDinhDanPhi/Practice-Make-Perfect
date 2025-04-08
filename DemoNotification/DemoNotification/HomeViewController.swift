//
//  HomeViewController.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var dropdown: DropdownMenuView = {
        let view = DropdownMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        view.addSubview(dropdown)
        
        // Cài đặt ràng buộc Auto Layout cho DropdownMenuView nếu cần thiết
        NSLayoutConstraint.activate([
            dropdown.topAnchor.constraint(equalTo: view.topAnchor),
            dropdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dropdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dropdown.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
