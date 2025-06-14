//
//  PhoneLoginViewController.swift
//  FactoryPatternDemo
//
//  Created by dan phi on 14/6/25.
//

import UIKit

class PhoneLoginViewController: BaseLoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Login with Phone"
        usernameTextField.placeholder = "Phone Number"
        passwordTextField.placeholder = "PIN Code"
    }

    override func login() {
        print("Phone Login: \(usernameTextField.text ?? "") | \(passwordTextField.text ?? "")")
    }
}
