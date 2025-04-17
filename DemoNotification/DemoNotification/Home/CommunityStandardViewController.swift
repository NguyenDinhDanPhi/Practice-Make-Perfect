//
//  CommunityStandardViewController.swift
//  DemoNotification
//
//  Created by Dan Phi on 16/4/25.
//


import UIKit

class CommunityStandardViewControlle2r: UIViewController {

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("< Quay lại", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Tiêu chuẩn cộng đồng"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .label
        label.text = String(repeating: """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec facilisis, urna ac tincidunt tincidunt, felis tellus iaculis odio, in maximus elit libero a sem. Duis risus metus, rhoncus ut porttitor at, fringilla ac ex. Proin fringilla placerat nisl vitae laoreet. In nibh augue, molestie in auctor sed, dictum eget leo. Fusce tempor purus a leo tempor varius. Mauris risus lorem, convallis vitae dictum sollicitudin, volutpat ac mi. Nam sagittis a elit vel tincidunt. Aenean et quam eleifend, laoreet velit nec, commodo enim. Proin eget lacus auctor, porttitor ante vitae, malesuada libero. Proin efficitur tempor semper. Quisque vehicula id felis quis placerat. Etiam eu dui finibus, vestibulum felis ut, volutpat nisi.

        """, count: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
    }

    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            scrollView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    @objc private func didTapBack() {
        dismiss(animated: true)
    }
}
