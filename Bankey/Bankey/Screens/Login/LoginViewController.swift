//
//  ViewController.swift
//  Bankey
//
//  Created by dan phi on 23/01/2025.
//

import UIKit

class LoginViewController: UIViewController {
    lazy var loginView = LoginView()
    
    lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        
        button.setTitle("Sign in", for: [])
        button.addTarget(self, action: #selector(signinTapped), for: .primaryActionTriggered)
        return button
    }()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .red
        label.numberOfLines = 0
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupLayout()
        view.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        loginView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorLabel)
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1),
            
            signInButton.topAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 20),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: signInButton.trailingAnchor, multiplier: 1),
            
            errorLabel.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
        ])
    }
    
    @objc func signinTapped() {
//        if let username = loginView.userNameTextfield.text,
//           let password = loginView.passwordTextfield.text,
//           username.isEmpty || password.isEmpty {
//            errorLabel.isHidden = false
//            errorLabel.text = "user / pass can't blank"
//        }
    }
    
}

