//
//  ViewController.swift
//  demoVNID
//
//  Created by Dan Phi on 9/9/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    private lazy var waitingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Chờ duyệt", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapWaiting), for: .touchUpInside)
        return button
    }()
    
    private lazy var approvedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Đã duyệt", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapApproved), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupLayout()
    }
    
    // MARK: - Actions
    @objc private func didTapWaiting() {
        let vc = BecomeStreamerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapApproved() {
        let vc = StartStreamerViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Layout
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [waitingButton, approvedButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 200),
            stack.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

