//
//  ViewController.swift
//  SimpleDelegate
//
//  Created by Dan Phi on 5/6/25.
//

import UIKit

protocol GetTextProtocol: AnyObject {
    func didUpdateText(_ text: String)
}

class ViewController: UIViewController, NextViewControllerDelegate {
  
    
    private lazy var textFieldView: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter text"
        return tf
    }()
    
    private lazy var buttonNext: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("NEXT", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return btn
    }()
    
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
    
    weak var delegate: GetTextProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(textFieldView)
        view.addSubview(buttonNext)
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textFieldView.widthAnchor.constraint(equalToConstant: 400),
            textFieldView.heightAnchor.constraint(equalToConstant: 70),
            
            buttonNext.topAnchor.constraint(equalTo: textFieldView.bottomAnchor, constant: 20),
            buttonNext.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            buttonNext.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            buttonNext.heightAnchor.constraint(equalToConstant: 50),
            
            textLabel.topAnchor.constraint(equalTo: buttonNext.bottomAnchor, constant: 20),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func textFieldDidChange() {
        if let enteredText = textFieldView.text {
                // Kiểm tra xem chuỗi có rỗng hay không sau khi đã unwrap
                if enteredText.isEmpty {
                    delegate?.didUpdateText("Text is empty")
                } else {
                    delegate?.didUpdateText(enteredText)
                }
            } else {
                // Trường hợp này hiếm khi xảy ra với UITextField.text nhưng vẫn là một khả năng kỹ thuật
                delegate?.didUpdateText("ext field has no text (nil)")
            }
        }
    
    @objc func handleNext() {
            let nextVC = NextViewController()
            // *** ĐIỂM QUAN TRỌNG NHẤT: GÁN NextViewController làm delegate cho ViewController hiện tại ***
            // Điều này cho phép NextViewController nhận dữ liệu từ ViewController
            self.delegate = nextVC
            nextVC.delegate = self
            // Gọi didUpdateText một lần khi chuyển màn hình để đảm bảo
            // NextViewController có dữ liệu ban đầu nếu đã có text trong textFieldView
            textFieldDidChange()
            
            // Hiển thị NextViewController
            present(nextVC, animated: true)
        }
    
    func nextViewControllerDidGetText(_ text: String) {
        textLabel.text = text
    }
    
}
