//
//  ViewController.swift
//  DemoHaishinKit
//
//  Created by Dan Phi on 12/6/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let button = UIButton(type: .system)
        button.setTitle("Go to A", for: .normal)
        button.addTarget(self, action: #selector(presentAViewController), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func presentAViewController() {
        let vc = AViewController()
              if let sheet = vc.sheetPresentationController {
                  sheet.detents = [.medium()]
                  sheet.prefersGrabberVisible = true
              }
              present(vc, animated: true)
    }
}
