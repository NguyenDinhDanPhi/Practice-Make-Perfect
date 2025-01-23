//
//  ViewController.swift
//  Bankey
//
//  Created by dan phi on 23/01/2025.
//

import UIKit

class LoginViewController: UIViewController {
    lazy var loginView = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
        view.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginView)
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1),
        ])
    }
    
}

