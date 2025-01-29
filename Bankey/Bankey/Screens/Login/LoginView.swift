//
//  LoginView.swift
//  Bankey
//
//  Created by dan phi on 23/01/2025.
//

import UIKit

class LoginView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var userNameTextfield: UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "User name"
        tf.delegate = self
        return tf
    }()
    
    lazy var passwordTextfield: UITextField = {
        var tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Pass word"
        tf.isSecureTextEntry = true
        tf.delegate = self
        return tf
    }()
    
    lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical
        return stack
    }()
    
    lazy var driverView: UIView = {
        let driver = UIView()
        driver.translatesAutoresizingMaskIntoConstraints = false
        driver.backgroundColor = .secondarySystemFill
        return driver
    }()
    private func setupLayout() {
        addSubview(stackView)
        backgroundColor = .secondarySystemBackground
        stackView.addArrangedSubview(userNameTextfield)
        stackView.addArrangedSubview(driverView)
        stackView.addArrangedSubview(passwordTextfield)
        passwordTextfield.enablePasswordToggle()

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1),
            
            userNameTextfield.heightAnchor.constraint(equalToConstant: 40),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 40),
            
            driverView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
//MARK: Delegate
extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextfield.endEditing(true)
        passwordTextfield.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            return false
        }
    }
}
