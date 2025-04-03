//
//  NotificationNotLogin.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//

import UIKit

class NotificationNotLogin: UIView {
    
    var singupAction: (() -> Void)?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empy") // Thay thế tên hình ảnh logo của bạn
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Đăng nhập hoặc Đăng ký để nhận thông báo"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Theo dõi, yêu thích và ứng hộ idol của bạn"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Đăng nhập hoặc Đăng ký", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(hex: "#FFC414") // Màu vàng cho nút
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(actionButtonTap), for: .touchUpInside)
        return button
    }()
    
    // Khởi tạo view
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .white
        
        // Thêm các thành phần con vào view chính
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(signUpButton)
        
        // Cài đặt Auto Layout
        NSLayoutConstraint.activate([
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150), // Điều chỉnh kích thước logo
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            signUpButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            signUpButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func actionButtonTap() {
        singupAction?()
    }
}

extension UIColor {
    // Tiện ích để chuyển đổi mã hex thành UIColor
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
