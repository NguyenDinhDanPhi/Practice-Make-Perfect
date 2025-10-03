//
//  RequiredNumberPhone.swift
//  TestNumberPhone
//
//  Created by Dan Phi on 3/10/25.
//

import UIKit

final class RequiredNumberPhone: UIViewController, KeyboardAdjustable {

    // MARK: - KeyboardAdjustable
    var bottomConstraint: NSLayoutConstraint?
    let bottomSpacingWhenHidden: CGFloat = -16
    var keyboardPadding: CGFloat = 0
    private let spacingBetweenButtonAndCheckbox: CGFloat = 12
    private let buttonHeight: CGFloat = 48
    
    // MARK: - UI
    private lazy var bgBackground: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "bg")
        return v
    }()
    
    private lazy var titleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Nhập số điện thoại để tiếp tục"
        v.font = .systemFont(ofSize: 28, weight: .bold)
        v.textColor = UIColor(hex: "#FFFFFF")
        v.numberOfLines = 2
        return v
    }()
    
    private lazy var textfield: UITextField = {
        let v = UITextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(hex: "#FFFFFF", alpha: 0.06)
        v.layer.cornerRadius = 8
        v.textColor = .white
        v.keyboardType = .phonePad
        v.clearButtonMode = .whileEditing
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        v.leftViewMode = .always
        v.attributedPlaceholder = NSAttributedString(
            string: "nhập số điện thoại của bạn",
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.5)]
        )
        return v
    }()
    
    private lazy var button: GradientButton = {
        let v = GradientButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Tiếp tục", for: .normal)
        v.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        return v
    }()
    
    private lazy var checkbox: CheckBox = {
        let v = CheckBox()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var privacyLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        
        let fullText = "Tôi đã đọc và đồng ý với Điều kiện và Điều khoản sử dụng FPT Play"
        let highlightText = "Điều kiện và Điều khoản sử dụng FPT Play"
        
        let baseAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(white: 1, alpha: 0.6),
            .font: UIFont.systemFont(ofSize: 14)
        ]
        let att = NSMutableAttributedString(string: fullText, attributes: baseAttrs)
        let nsRange = (fullText as NSString).range(of: highlightText, options: .caseInsensitive)
        if nsRange.location != NSNotFound {
            att.addAttributes([
                .foregroundColor: UIColor(hex: "#FE592A"),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }
        lb.attributedText = att
        return lb
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupKeyboardObservers() // từ protocol
        
        // Tap nền để ẩn bàn phím
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
        
        // Checkbox auto tick
        checkbox.isChecked = true
        checkbox.addTarget(self, action: #selector(checkboxChanged), for: .touchUpInside)
        
        updateButtonState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textfield.becomeFirstResponder()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        view.addSubview(bgBackground)
        view.addSubview(titleLabel)
        view.addSubview(textfield)
        view.addSubview(button)
        view.addSubview(checkbox)
        view.addSubview(privacyLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            bgBackground.topAnchor.constraint(equalTo: view.topAnchor),
            bgBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgBackground.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.521),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            
            textfield.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textfield.heightAnchor.constraint(equalToConstant: 48),
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: buttonHeight),
            button.bottomAnchor.constraint(equalTo: checkbox.topAnchor, constant: -spacingBetweenButtonAndCheckbox),
            
            checkbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkbox.widthAnchor.constraint(equalToConstant: 20),
            checkbox.heightAnchor.constraint(equalToConstant: 20),
            
            privacyLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            privacyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            privacyLabel.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor)
        ])
        
        bottomConstraint = checkbox.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                           constant: bottomSpacingWhenHidden)
        bottomConstraint?.isActive = true
    }
    
    // MARK: - Actions
    @objc private func didTapContinue() {
        print("Tiếp tục với số: \(textfield.text ?? "")")
    }
    
    @objc private func checkboxChanged() { updateButtonState() }
    
    private func updateButtonState() {
        button.isEnabled = checkbox.isChecked
    }
}

// MARK: - Helpers
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}
