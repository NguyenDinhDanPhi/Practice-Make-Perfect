//
//  ViewController.swift
//  demoOnboarding
//
//  Created by Dan Phi on 16/6/25.
//

import UIKit

class ViewController: UIViewController {
    private let showOnboardingButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Show Onboarding", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Main"
        setupLayout()
        showOnboardingButton.addTarget(self, action: #selector(didTapShowOnboarding), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(showOnboardingButton)
        NSLayoutConstraint.activate([
            showOnboardingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showOnboardingButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showOnboardingButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func didTapShowOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }
}

