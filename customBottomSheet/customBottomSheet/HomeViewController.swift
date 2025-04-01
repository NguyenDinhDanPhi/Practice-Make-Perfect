//
//  ViewController.swift
//  customBottomSheet
//
//  Created by dan phi on 20/3/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    lazy var bottomSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Bottom Sheet", for: .normal)
        button.addTarget(self, action: #selector(showBottomSheet), for: .touchUpInside)
        return button
    }()
    
    lazy var navigationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Navigation", for: .normal)
        button.addTarget(self, action: #selector(showNavigation), for: .touchUpInside)
        return button
    }()
    
    lazy var stack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bottomSheetButton, navigationButton])
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300),
            stack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func showBottomSheet() {
        let viewModel = CaseViewViewModel()
        let caseViewController = UIViewController()
        let caseView = CaseView(viewModel: viewModel,buttonStyle: .twoButton)
        caseView.backgroundColor = .clear
        caseView.translatesAutoresizingMaskIntoConstraints = false
        
        caseViewController.view.addSubview(caseView)
        caseViewController.view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            caseView.centerXAnchor.constraint(equalTo: caseViewController.view.centerXAnchor),
            caseView.centerYAnchor.constraint(equalTo: caseViewController.view.centerYAnchor),
            caseView.leadingAnchor.constraint(equalTo: caseViewController.view.leadingAnchor, constant: 20),
            caseView.trailingAnchor.constraint(equalTo: caseViewController.view.trailingAnchor, constant: -20)
        ])
        
        viewModel.onRetryAction = {
            print("Retry button pressed in BottomSheet")
        }
        viewModel.onBackAction = {
            print("Back button pressed in BottomSheet")
        }
        viewModel.onExisteAction = {
            print("Exit button pressed in BottomSheet")
        }
        
        if let sheet = caseViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(caseViewController, animated: true)
    }
    
    @objc func showNavigation() {
        let viewModel = CaseViewViewModel()
        let caseViewController = UIViewController()
        let caseView = CaseView(viewModel: viewModel,buttonStyle: .twoButton)
        caseView.backgroundColor = .white
        caseView.translatesAutoresizingMaskIntoConstraints = false
        
        caseViewController.view.addSubview(caseView)
        caseViewController.view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            caseView.centerXAnchor.constraint(equalTo: caseViewController.view.centerXAnchor),
            caseView.centerYAnchor.constraint(equalTo: caseViewController.view.centerYAnchor),
            caseView.leadingAnchor.constraint(equalTo: caseViewController.view.leadingAnchor, constant: 20),
            caseView.trailingAnchor.constraint(equalTo: caseViewController.view.trailingAnchor, constant: -20)
        ])
        viewModel.onRetryAction = {
            print("Retry button pressed in BottomSheet")
        }
        viewModel.onBackAction = {
            print("Back button pressed in BottomSheet")
        }
        viewModel.onExisteAction = {
            print("Exit button pressed in BottomSheet")
        }
        
        navigationController?.pushViewController(caseViewController, animated: true)
    }
}
