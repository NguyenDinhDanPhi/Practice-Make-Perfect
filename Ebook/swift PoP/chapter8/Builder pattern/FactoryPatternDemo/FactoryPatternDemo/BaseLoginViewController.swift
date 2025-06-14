//
//  BaseLoginViewController.swift
//  FactoryPatternDemo
//
//  Created by dan phi on 14/6/25.
//

import UIKit

class BaseLoginViewController: UIViewController, LoginHandling {
    
    let titleLabel = UILabel()
    let usernameTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseUI()
    }

    func login() {
        fatalError("Subclasses must override login()")
    }

    @objc private func didTapLogin() {
        dismiss(animated: true)
        login()
    }

    private func setupBaseUI() {
        view.backgroundColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center

        usernameTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true

        loginButton.setTitle("Login", for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)

        [titleLabel, usernameTextField, passwordTextField, loginButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor),

            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
