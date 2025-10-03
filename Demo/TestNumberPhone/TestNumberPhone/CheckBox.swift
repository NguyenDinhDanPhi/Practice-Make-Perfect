//
//  CheckBox.swift
//  TestNumberPhone
//
//  Created by Dan Phi on 3/10/25.
//

import UIKit
// MARK: - CheckBox
final class CheckBox: UIButton {
    private let checkedImage = UIImage(systemName: "checkmark.square.fill")
    private let uncheckedImage = UIImage(systemName: "square")
    
    var isChecked: Bool = false {
        didSet {
            setImage(isChecked ? checkedImage : uncheckedImage, for: .normal)
            tintColor = UIColor(hex: "#FE592A")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(uncheckedImage, for: .normal)
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    @objc private func toggle() { isChecked.toggle() }
}
