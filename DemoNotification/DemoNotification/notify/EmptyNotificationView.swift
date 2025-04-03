//
//  EmptyNotificationView.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//

import UIKit

class EmptyNotificationView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyInboxImage") // Thay thế bằng tên ảnh của bạn
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hộp thư đang trống"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hiện tại chưa có gì mới. Hãy tiếp tục khám phá, mình sẽ thông báo khi có cập nhật mới!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0 // Cho phép hiển thị nhiều dòng
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        // Cài đặt background và layout
        backgroundColor = .white
        
        // Thêm các thành phần con vào view chính
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        // Cài đặt Auto Layout
        NSLayoutConstraint.activate([
            //imageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 150), // Kích thước hình minh họa
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
}
