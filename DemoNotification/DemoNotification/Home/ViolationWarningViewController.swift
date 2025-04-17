//
//  ViolationWarningViewController.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//

import UIKit

class ViolationWarningViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 14
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var warningIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill"))
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Đã xóa bình luận"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bình luận này vi phạm Tiêu chuẩn Cộng đồng của chúng tôi"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        
        let fullText = "Hãy đọc Tiêu chuẩn Cộng đồng của chúng tôi"
        let attributedString = NSMutableAttributedString(string: fullText)
        // Tìm vị trí "Tiêu chuẩn Cộng đồng" trong chuỗi và áp dụng các thuộc tính
        let targetText = "Tiêu chuẩn Cộng đồng"
        let range = (fullText as NSString).range(of: targetText)
        // Định dạng cho từ "Tiêu chuẩn Cộng đồng"
        attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: range)  // In đậm
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)  // Gạch chân
        label.font = .systemFont(ofSize: 13)
        label.attributedText = attributedString
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true  
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let bgColor = UIColor(named: "background") {
            view.backgroundColor = bgColor
        } else {
            view.backgroundColor = .red
        }
       
        setupViews()
        setupContent()
    }
    
    // MARK: - Setup UI
    
    private func setupViews() {
        view.addSubview(stackView)
        view.addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            footerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            footerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            footerLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupContent() {
        stackView.addArrangedSubview(warningIcon)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        
        stackView.addArrangedSubview(InfoBoxView(
            title: "Cảnh báo",
            content: "Bạn nhận được cảnh báo về hành vi vi phạm. Bạn sẽ bị cảnh cáo nếu tiếp tục vi phạm.",
            titleColor: .systemRed
        ))

        stackView.addArrangedSubview(InfoBoxView(
            title: "Chi tiết bình luận",
            content: "“Tự xử đi”",
            time: "Đăng ngày 27/03/2025 lúc 09:42"
        ))

        stackView.addArrangedSubview(InfoBoxView(
            title: "Lý do vi phạm",
            content: "Tiêu chuẩn Cộng đồng",
            subContent: """
            Nội dung của bạn vi phạm Tiêu chuẩn Cộng đồng của chúng tôi. Tiêu chuẩn này bao gồm quy tắc và chuẩn mực về việc sử dụng FangTV, áp dụng cho tất cả mọi người và mọi nội dung trên nền tảng của chúng tôi.
            """
        ))
    }
    
    
    @objc func handleLabelTap() {
        print("haha")
        let vc = CommunityStandardViewControlle2r()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)

    }
}
