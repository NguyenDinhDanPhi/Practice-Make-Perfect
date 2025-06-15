//
//  AViewController.swift
//  DemoHaishinKit
//
//  Created by dan phi on 12/6/25.
//

import UIKit

class AViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        let button = UIButton(type: .system)
        button.setTitle("Go to B", for: .normal)
        button.addTarget(self, action: #selector(fetchAndPresentB), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func fetchAndPresentB() {
        BViewController.presentIfNeeded(
            from: self,
            onPostResult: { [weak self] success in
                let message = success ? "🎉 Post thành công!" : "❌ Post thất bại!"
                self?.showToast(message: message)
            },
            onFetchFailed: { [weak self] in
                self?.showToast(message: "⚠️ Không tải được dữ liệu!")
            }
        )
    }


    private func showToast(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true)
        }
    }


}

