//
//  RequiredNumberPhone.swift
//  TestNumberPhone
//
//  Created by Dan Phi on 3/10/25.
//

import UIKit

final class RequiredNumberPhone: UIViewController, KeyboardAdjustable, UITextFieldDelegate {

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
        v.keyboardType = .numberPad
        v.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 48))
        v.leftViewMode = .always
        v.attributedPlaceholder = NSAttributedString(
            string: "nhập số điện thoại của bạn",
            attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.5)]
        )
        v.delegate = self
        return v
    }()

    private lazy var errorLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Số điện thoại không hợp lệ"
        v.textColor = .red
        v.font = .systemFont(ofSize: 12, weight: .regular)
        v.textAlignment = .left
        v.isHidden = true
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
        setupKeyboardObservers()

        // Tap nền để ẩn bàn phím
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))

        // Checkbox auto tick
        checkbox.isChecked = true
        checkbox.addTarget(self, action: #selector(checkboxChanged), for: .touchUpInside)

        // ⚠️ Thêm target: sửa là ẩn lỗi và reset border
        textfield.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)

        updateButtonState() // nút phụ thuộc checkbox
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
        view.addSubview(errorLabel)
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

            errorLabel.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),

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
        let text = textfield.text ?? ""
        if isValidPhone(text) {
            clearErrorUI()
            print("Tiếp tục với số: \(text)")
            // TODO: push/present bước tiếp theo...
        } else {
            showErrorUI("Số điện thoại không hợp lệ")
        }
        updateButtonState() // nút vẫn theo checkbox
    }

    @objc private func onEditingChanged() {
        if !errorLabel.isHidden { 
            clearErrorUI()
        }
    }

    @objc private func checkboxChanged() { updateButtonState() }

    private func updateButtonState() {
        button.isEnabled = checkbox.isChecked
        button.alpha = button.isEnabled ? 1.0 : 0.5
    }

    // MARK: - Validation (chỉ khi bấm nút)
    func isValidPhone(_ s: String) -> Bool {
        return !s.isEmpty && s.allSatisfy(\.isNumber) && s.count == 10
    }

    // MARK: - UITextFieldDelegate (giới hạn 10 số, chặn ký tự khác)
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        // Cho phép xóa/backspace
        if string.isEmpty { return true }

        // Chỉ cho nhập ký tự số 0-9
        let isAllDigits = string.unicodeScalars.allSatisfy { CharacterSet.decimalDigits.contains($0) }
        if !isAllDigits { return false }

        // Không vượt quá 10 ký tự (kể cả paste)
        let current = textField.text ?? ""
        if let r = Range(range, in: current) {
            let next = current.replacingCharacters(in: r, with: string)
            return next.count <= 10
        }
        return false
    }

    // MARK: - Error UI
    private func showErrorUI(_ message: String) {
        textfield.layer.borderWidth = 1
        textfield.layer.borderColor = UIColor.systemRed.cgColor
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    private func clearErrorUI() {
        textfield.layer.borderWidth = 0
        textfield.layer.borderColor = UIColor.clear.cgColor
        errorLabel.isHidden = true
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
