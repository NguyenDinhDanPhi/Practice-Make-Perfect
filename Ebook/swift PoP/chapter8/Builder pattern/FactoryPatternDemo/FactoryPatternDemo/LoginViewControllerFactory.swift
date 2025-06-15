
//
//  LoginViewControllerFactỏy.swift
//  FactoryPatternDemo
//
//  Created by dan phi on 14/6/25.
//

enum LoginType {
    case email, phone, apple, google

}

protocol LoginHandling {
    func login()
}

import UIKit

class LoginViewControllerFactory {
    static func createLoginViewController(for type: LoginType) -> (UIViewController & LoginHandling) {
        switch type {
        case .email:
            return EmailLoginViewController() //EmailLoginViewController()
        case .phone:
            return PhoneLoginViewController()
        case .apple:
            return AppleLoginViewController()
        case .google:
            return GoogleLoginViewController()
        }
    }
}

class EmailLoginViewController: BaseLoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Login with Email"
        usernameTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
    }

    override func login() {
        print("Email Login: \(usernameTextField.text ?? "") | \(passwordTextField.text ?? "")")
    }
}
