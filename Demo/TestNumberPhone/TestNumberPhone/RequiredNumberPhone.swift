//
//  RequiredNumberPhone.swift
//  TestNumberPhone
//
//  Created by Dan Phi on 3/10/25.
//

import UIKit

final class RequiredNumberPhone: UIViewController {
    
    // MARK: - Keyboard bottom constraint
    private var bottomConstraint: NSLayoutConstraint?
    private let bottomSpacingWhenHidden: CGFloat = -16
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
        setupKeyboardObservers()
        
        // Tap nền để ẩn bàn phím
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing)))
        
        // Checkbox auto tick
        checkbox.isChecked = true
        checkbox.addTarget(self, action: #selector(checkboxChanged), for: .touchUpInside)
        
        // Cập nhật trạng thái nút lần đầu
        updateButtonState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Auto focus
        textfield.becomeFirstResponder()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
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
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
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
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboard(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    // MARK: - Actions
    @objc private func didTapContinue() {
        print("Tiếp tục với số: \(textfield.text ?? "")")
    }
    
    @objc private func checkboxChanged() { updateButtonState() }
    
    private func updateButtonState() {
        button.isEnabled = checkbox.isChecked
    }
    
    // MARK: - Keyboard
    @objc private func handleKeyboard(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
        else { return }
        
        var overlap: CGFloat = 0
        if let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let kbEnd = view.convert(endFrame, from: nil)
            overlap = max(0, view.bounds.maxY - kbEnd.origin.y)
        }
        
        if overlap > 0 {
            bottomConstraint?.constant = -(overlap + 12)
        } else {
            bottomConstraint?.constant = bottomSpacingWhenHidden
        }
        
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            self.view.layoutIfNeeded()
        }
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

// MARK: - GradientButton
final class GradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    
    override var isEnabled: Bool {
        didSet { updateStyle() }
    }
    
    override init(frame: CGRect) { super.init(frame: frame); setupGradient() }
    required init?(coder: NSCoder) { super.init(coder: coder); setupGradient() }
    
    private func setupGradient() {
        gradientLayer.colors = [
            UIColor(hex: "#FE592A").cgColor,
            UIColor(hex: "#FD3C12").cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        updateStyle()
    }
    
    private func updateStyle() {
        if isEnabled {
            gradientLayer.isHidden = false
            backgroundColor = .clear
            setTitleColor(.white, for: .normal)
        } else {
            gradientLayer.isHidden = true
            backgroundColor = UIColor.black.withAlphaComponent(0.06)
            setTitleColor(UIColor.white.withAlphaComponent(0.38), for: .normal)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
}

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
