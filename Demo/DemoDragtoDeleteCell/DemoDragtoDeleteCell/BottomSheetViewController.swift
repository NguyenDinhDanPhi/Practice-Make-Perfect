//
//  TestVIew.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 2/4/25.
//

import UIKit

class BottomSheetViewController: UIViewController {

    private let containerView = UIView()
    private let grabber = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupContainer()
        setupIcons()
    }

    private func setupBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        view.addGestureRecognizer(tap)
    }

    private func setupContainer() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 180) // tùy chỉnh chiều cao
        ])

        // Grabber
        grabber.backgroundColor = UIColor.lightGray
        grabber.layer.cornerRadius = 3
        containerView.addSubview(grabber)
        grabber.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            grabber.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            grabber.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            grabber.widthAnchor.constraint(equalToConstant: 40),
            grabber.heightAnchor.constraint(equalToConstant: 5)
        ])
    }

    private func setupIcons() {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 16

        let icons = [
            ("instagram", "Instagram"),
            ("message.fill", "SMS"),
            ("whatsapp", "Whatsapp"),
            ("twitter", "Twitter"),
            ("ellipsis", "Thêm")
        ]

        for (iconName, title) in icons {
            let v = createIcon(icon: iconName, title: title)
            stack.addArrangedSubview(v)
        }

        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func createIcon(icon: String, title: String) -> UIView {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: icon)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.backgroundColor = .systemGreen
        imageView.layer.cornerRadius = 28
        imageView.clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 56),
            imageView.heightAnchor.constraint(equalToConstant: 56)
        ])

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [imageView, label])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 4
        return stack
    }

    @objc private func dismissSheet() {
        dismiss(animated: true, completion: nil)
    }
}
