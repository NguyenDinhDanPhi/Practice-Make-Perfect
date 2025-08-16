//
//  ViewController.swift
//  UpLoad and Edit video
//
//  Created by Dan Phi on 30/7/25.
//

import UIKit
import AVKit

class UploadViewController: UIViewController {
    private let selectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Chọn video để tải lên", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    private let listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Xem danh sách video", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upload Video"
        view.backgroundColor = .white
        setupLayout()
        
        selectButton.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    }
    
    private func setupLayout()  {
        view.addSubview(selectButton)
        view.addSubview(listButton)
        NSLayoutConstraint.activate([
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            listButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc private func selectVideo() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeMedium
        picker.modalPresentationStyle = .fullScreen
        present(picker, animated: true)
    }
    
    @objc private func showList() {
        guard let nav = navigationController else {
            print("⚠️ navigationController is nil – hãy kiểm tra SceneDelegate xem đã embed chưa")
            return
        }
        let listVC = VideoListViewController()
        nav.pushViewController(listVC, animated: true)
    }

    
    
    
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let url = info[.mediaURL] as? URL else { return }
        do {
            try VideoManager.shared.saveVideo(at: url)
            // Chuyển thẳng vào EditViewController với URL gốc hoặc URL đã save
            let editVC = EditViewController(sourceURL: url)
            navigationController?.pushViewController(editVC, animated: true)
            
        } catch {
            let alert = UIAlertController(title: "Lỗi",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
}

