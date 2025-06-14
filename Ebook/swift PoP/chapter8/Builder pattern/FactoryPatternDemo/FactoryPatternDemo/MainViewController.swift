//
//  ViewController.swift
//  FactoryPatternDemo
//
//  Created by dan phi on 14/6/25.
//

import UIKit

class MainViewController: UIViewController {
    
    let loginTypes: [LoginType] = [.email, .phone, .apple, .google]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "QuickAuth Login Demo"

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])

        for type in loginTypes {
            let button = UIButton(type: .system)
            button.setTitle(titleForLoginType(type), for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 18)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
            button.heightAnchor.constraint(equalToConstant: 44).isActive = true
            button.tag = tagForLoginType(type)
            button.addTarget(self, action: #selector(didTapLoginButton(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
    }

    private func titleForLoginType(_ type: LoginType) -> String {
        switch type {
        case .email: return "Login with Email"
        case .phone: return "Login with Phone"
        case .apple: return "Login with Apple"
        case .google: return "Login with Google"
        }
    }

    private func tagForLoginType(_ type: LoginType) -> Int {
        switch type {
        case .email: return 0
        case .phone: return 1
        case .apple: return 2
        case .google: return 3
        }
    }

    private func loginTypeForTag(_ tag: Int) -> LoginType {
        switch tag {
        case 0: return .email
        case 1: return .phone
        case 2: return .apple
        case 3: return .google
        default: return .email
        }
    }

    @objc private func didTapLoginButton(_ sender: UIButton) {
        let loginType = loginTypeForTag(sender.tag)
        let loginVC = LoginViewControllerFactory.createLoginViewController(for: loginType)
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}

