//
//  CaseViewController.swift
//  customBottomSheet
//
//  Created by dan phi on 21/3/25.
//

import UIKit

class CaseView: UIView {
    
    private var buttonStyle: ButtonStyle
    
    init(buttonStyle: ButtonStyle) {
        self.buttonStyle = buttonStyle
        super.init(frame: .zero)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "main"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtitle"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var stackViewTitle: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    private lazy var stackViewButton: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func setUpView() {
        addSubview(imageView)
        addSubview(stackViewTitle)
        addSubview(stackViewButton)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            
            stackViewTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            stackViewTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackViewTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            
            stackViewButton.topAnchor.constraint(equalTo: stackViewTitle.bottomAnchor, constant: 16),
            stackViewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackViewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackViewButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        switch buttonStyle {
        case .oneButton:
            stackViewButton.addArrangedSubview(retryButton)
            retryButton.backgroundColor = .black
        case .twoButton:
            [retryButton, backButton].forEach { stackViewButton.addArrangedSubview($0) }
            retryButton.backgroundColor = .black
            backButton.backgroundColor = .clear
           

        case .threeButton:
            [retryButton, backButton, exitButton].forEach { stackViewButton.addArrangedSubview($0) }
            retryButton.backgroundColor = .black
            backButton.backgroundColor = .lightGray
            exitButton.backgroundColor = .clear
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let totalHeight = 150 + 16 + stackViewTitle.intrinsicContentSize.height + 16 + stackViewButton.intrinsicContentSize.height + 20
        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }
}

enum ButtonStyle {
    case oneButton
    case twoButton
    case threeButton
}
