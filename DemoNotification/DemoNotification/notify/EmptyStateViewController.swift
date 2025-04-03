//
//  EmptyStateViewController.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//

//
//  EmptyStateView.swift
//  Streaming
//
//  Created by dan phi on 24/3/25.
//
import UIKit

// Parameter
struct EmptyStateViewData {
    var numberOfButtons: NumberOfButtons
    var titleText: String
    var subtitleText: String
    var imageDetails:String
    var textRetryButton: String
    var textBackButton: String
    var textExistButton: String
}

class EmptyStateViewController: UIViewController {
    
    private var numberOfButtons: NumberOfButtons
    private var titleText: String
    private var subtitleText: String
    private var imageDetails: String
    private var textRetryButton: String
    private var textBackButton: String
    private var textExistButton: String
    private let metrics: LayoutMetrics
    //MARK: CALLBACK ACTION
    var onRetryAction: (() -> Void)?
    var onBackAction: (() -> Void)?
    var onExisteAction: (() -> Void)?
    
   
    static func createEmptyStateViewController(data: EmptyStateViewData) -> EmptyStateViewController {
        return EmptyStateViewController(data: data)
    }
    
    private init(data: EmptyStateViewData) {
        self.numberOfButtons = data.numberOfButtons
        self.titleText = data.titleText
        self.subtitleText = data.subtitleText
        self.imageDetails = data.imageDetails
        self.textRetryButton = data.textRetryButton
        self.textBackButton = data.textBackButton
        self.textExistButton = data.textExistButton
        self.metrics = LayoutMetrics.default
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: imageDetails)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = titleText
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = subtitleText
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var stackViewTitle: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(textRetryButton, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(retryButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(textBackButton, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(textExistButton, for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 8
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(exisButtonAction), for: .touchUpInside)
        
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
        view.addSubview(imageView)
        view.addSubview(stackViewTitle)
        view.addSubview(stackViewButton)
        view.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: metrics.imageTopOffset),
            imageView.heightAnchor.constraint(equalToConstant: metrics.imageSize.height),
            imageView.widthAnchor.constraint(equalToConstant: metrics.imageSize.width),
            
            stackViewTitle.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: metrics.stackViewSpacing),
            stackViewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: metrics.stackViewHorizontalPadding),
            stackViewTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -metrics.stackViewHorizontalPadding),
            
            stackViewButton.topAnchor.constraint(equalTo: stackViewTitle.bottomAnchor, constant: metrics.stackViewSpacing),
            stackViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: metrics.stackViewHorizontalPadding),
            stackViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -metrics.stackViewHorizontalPadding),
        ])
        
        switch numberOfButtons {
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
            backButton.backgroundColor = .gray
            exitButton.backgroundColor = .clear
        }
    }
    
    @objc func retryButtonAction() {
        onRetryAction?()
    }
    
    @objc func backButtonAction() {
        onBackAction?()
    }
    
    @objc func exisButtonAction() {
        onExisteAction?()
    }
    
    func addToParentViewController(_ parent: UIViewController, in containerView: UIView) {
        addChild(self, to: parent, in: containerView)
    }
    
    private func addChild(_ child: UIViewController, to parent: UIViewController, in containerView: UIView) {
        parent.addChild(child)
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        child.didMove(toParent: parent)
    }
}

enum NumberOfButtons {
    case oneButton
    case twoButton
    case threeButton
}
//MARK: Struct LayoutConstain
struct LayoutMetrics {
    static let `default` = LayoutMetrics(
        imageSize: CGSize(width: 150, height: 150),
        imageTopOffset: -100,
        stackViewSpacing: 16,
        stackViewHorizontalPadding: 12,
        buttonHeight: 40,
        buttonSpacing: 8
    )
    
    let imageSize: CGSize
    let imageTopOffset: CGFloat
    let stackViewSpacing: CGFloat
    let stackViewHorizontalPadding: CGFloat
    let buttonHeight: CGFloat
    let buttonSpacing: CGFloat
}

