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
    
    private lazy var infoWarningBoxView: InfoBoxView = {
        return InfoBoxView(
            title: "Cảnh báo",
            content: "Bạn nhận được cảnh báo về hành vi vi phạm. Bạn sẽ bị cảnh cáo nếu tiếp tục vi phạm.",
            titleColor: .systemRed
        )
    }()
    
    private lazy var infoDetailBoxView: InfoBoxView = {
        return InfoBoxView(
            title: "Chi tiết bình luận",
            content:"“Tự xử đi”",
            time: "Đăng ngày 27/03/2025 lúc 09:42"
        )
    }()
    private let sheetTransitioningDelegate = PartialSheetTransitioningDelegate(heightRatio: 0.3)

    private lazy var infoReasonBoxView: InfoBoxView = {
        return InfoBoxView(
            title: "Lý do vi phạm",
            content: "Tiêu chuẩn Cộng đồng",
            subContent: """
            Nội dung của bạn vi phạm Tiêu chuẩn Cộng đồng của chúng tôi. Tiêu chuẩn này bao gồm quy tắc và chuẩn mực về việc sử dụng FangTV, áp dụng cho tất cả mọi người và mọi nội dung trên nền tảng của chúng tôi.
            """
        )
    }()
    
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        let fullText = "Hãy đọc Tiêu chuẩn Cộng đồng của chúng tôi"
        let attributedString = NSMutableAttributedString(string: fullText)
        let targetText = "Tiêu chuẩn Cộng đồng"
        let range = (fullText as NSString).range(of: targetText)
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
    }
    
    // MARK: - Setup UI
    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(warningIcon)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subtitleLabel)
        stackView.addArrangedSubview(infoWarningBoxView)
        stackView.addArrangedSubview(infoDetailBoxView)
        stackView.addArrangedSubview(infoReasonBoxView)
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
    
    @objc func handleLabelTap() {
        let vc = TestViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        present(vc, animated: true, completion: nil)
    }
}
