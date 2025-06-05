//
//  NextViewController.swift
//  SimpleDelegate
//
//  Created by Dan Phi on 5/6/25.
//
import UIKit

protocol NextViewControllerDelegate: AnyObject {
    func nextViewControllerDidGetText(_ text: String)
}

class NextViewController: UIViewController, GetTextProtocol {
    
    // MARK: - UI Elements
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label // Tự động đổi màu theo chế độ sáng/tối
        label.numberOfLines = 0 // Cho phép nhiều dòng
        label.text = "Waiting for text..." // Text mặc định
        return label
    }()
    
    weak var delegate: NextViewControllerDelegate?
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // Màu nền chung của hệ thống
        
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            textLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - GetTextProtocol Conformance
    
    // Phương thức bắt buộc phải triển khai từ GetTextProtocol
    func didUpdateText(_ text: String) {
        // Cập nhật text của UILabel khi nhận được dữ liệu từ delegate
        textLabel.text = text
        var check = "text from NextViewController \(text)"
        delegate?.nextViewControllerDidGetText(check)
    }
}
