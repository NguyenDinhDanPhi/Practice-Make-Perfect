//
//  UITextField+.swift
//  Bankey
//
//  Created by dan phi on 29/01/2025.
//

import UIKit
let passToggleButton = UIButton(type: .custom)
extension UITextField {
    
    func enablePasswordToggle() {
        passToggleButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        passToggleButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        rightView = passToggleButton
        rightViewMode = .always
        passToggleButton.addTarget(self, action: #selector(togglePass), for: .touchUpInside)
    }
    
    @objc func togglePass() {
        isSecureTextEntry.toggle()
        passToggleButton.isSelected.toggle()
    }
}
