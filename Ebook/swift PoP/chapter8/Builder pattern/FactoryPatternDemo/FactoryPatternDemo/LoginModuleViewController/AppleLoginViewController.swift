//
//  Untitled 2.swift
//  FactoryPatternDemo
//
//  Created by dan phi on 14/6/25.
//

import UIKit

class AppleLoginViewController: BaseLoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Login with Apple ID"
        usernameTextField.placeholder = "Apple ID"
        passwordTextField.placeholder = "Apple Password"
    }

    override func login() {
        print("Apple ID Login: \(usernameTextField.text ?? "") | \(passwordTextField.text ?? "")")
    }
}
