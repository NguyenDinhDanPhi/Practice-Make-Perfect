//
//  GoogleLoginViewController.swift
//  FactoryPatternDemo
//
//  Created by dan phi on 14/6/25.
//

import UIKit

class GoogleLoginViewController: BaseLoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Login with Google"
        usernameTextField.placeholder = "Google Account"
        passwordTextField.placeholder = "Google Password"
    
    }

    override func login() {
        print("Google Login: \(usernameTextField.text ?? "") | \(passwordTextField.text ?? "")")
    }
}
