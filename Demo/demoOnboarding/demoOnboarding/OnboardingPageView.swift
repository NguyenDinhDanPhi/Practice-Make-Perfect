//
//  OnboardingPageView.swift
//  demoOnboarding
//
//  Created by Dan Phi on 16/6/25.
//


import UIKit

class OnboardingPageView: UIView {
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 24, weight: .bold)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    init(image: UIImage?, title: String, description: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
        imageView.image = image
        titleLabel.text = title
        descriptionLabel.text = description
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupLayout() {
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        // Layout: tương tự ví dụ trước
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
