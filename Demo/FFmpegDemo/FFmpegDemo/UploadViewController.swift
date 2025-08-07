//
//  ViewController.swift
//  FFmpegDemo
//
//  Created by Dan Phi on 5/8/25.
//

import UIKit
import AVKit

// MARK: - UploadViewController
class UploadViewController: UIViewController {
    private let selectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Chọn Video", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.tintColor = .white
        btn.layer.cornerRadius = 25
        btn.backgroundColor = .systemBlue
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upload Video"
        view.backgroundColor = .white
        view.addSubview(selectButton)
        setupConstraints()
        selectButton.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            selectButton.heightAnchor.constraint(equalToConstant: 50),
            selectButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func selectVideo() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let mediaURL = info[.mediaURL] as? URL else { return }
        let editVC = EditViewController(videoURL: mediaURL)
        editVC.modalPresentationStyle = .fullScreen
        present(editVC, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
