//
//  UploadViewControllerMobileCoreServices.swift
//  UpLoad and Edit video
//
//  Created by Dan Phi on 30/7/25.
//

import UIKit
import MobileCoreServices
import AVFoundation
import Photos

class UploadViewControllerMobileCoreServices: UIViewController,
                                             UIImagePickerControllerDelegate,
                                             UINavigationControllerDelegate,
                                             UIVideoEditorControllerDelegate {
    
    // MARK: - UI Components
    private let selectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Chọn video để tải lên", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let listButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Xem danh sách video", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Properties
    private var tempVideoURL: URL?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Upload Video"
        view.backgroundColor = .systemBackground
        setupLayout()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("📱 UploadViewController viewWillAppear")
    }
    
    // MARK: - Setup
    private func setupLayout() {
        view.addSubview(selectButton)
        view.addSubview(listButton)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            selectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            selectButton.widthAnchor.constraint(equalToConstant: 200),
            selectButton.heightAnchor.constraint(equalToConstant: 50),
            
            listButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listButton.topAnchor.constraint(equalTo: selectButton.bottomAnchor, constant: 20),
            listButton.widthAnchor.constraint(equalToConstant: 200),
            listButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        selectButton.addTarget(self, action: #selector(selectVideo), for: .touchUpInside)
        listButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func selectVideo() {
        print("🎬 Bắt đầu chọn video")
        
        // Kiểm tra quyền truy cập Photos
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self?.presentVideoPicker()
                case .denied, .restricted:
                    self?.showAlert(title: "Không có quyền",
                                   message: "Vui lòng cấp quyền truy cập Photos trong Settings")
                case .notDetermined:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func presentVideoPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.videoQuality = .typeHigh
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        picker.allowsEditing = false // Tắt editing của picker, dùng UIVideoEditorController
        
        print("📹 Presenting video picker")
        present(picker, animated: true)
    }
    
    @objc private func showList() {
        print("📋 Chuyển đến danh sách video")
        let listVC = VideoListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print("✅ Đã chọn video từ picker")
        
        picker.dismiss(animated: true)
        
        guard let mediaURL = info[.mediaURL] as? URL else {
            print("❌ Không tìm thấy mediaURL")
            showAlert(title: "Lỗi", message: "Không thể lấy video")
            return
        }
        
        print("📍 Video URL:", mediaURL.path)
        print("📊 File exists:", FileManager.default.fileExists(atPath: mediaURL.path))
        
        // Lưu temp URL để dùng sau
        self.tempVideoURL = mediaURL
        
        // Kiểm tra xem có thể edit không
        if UIVideoEditorController.canEditVideo(atPath: mediaURL.path) {
            print("✂️ Video có thể edit, presenting editor...")
            presentVideoEditor(with: mediaURL)
        } else {
            print("⚠️ Video không thể edit, lưu trực tiếp")
            saveVideoDirectly(from: mediaURL)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("❌ User cancelled picker")
        picker.dismiss(animated: true)
    }
    
    // MARK: - Video Editor
    private func presentVideoEditor(with url: URL) {
        let editor = UIVideoEditorController()
        editor.videoPath = url.path
        editor.videoMaximumDuration = 600 // 10 phút
        editor.videoQuality = .typeHigh
        editor.delegate = self
        editor.modalPresentationStyle = .fullScreen
        
        print("🎬 Presenting video editor với path:", url.path)
        present(editor, animated: true)
    }
    
    // MARK: - UIVideoEditorControllerDelegate
    func videoEditorController(_ editor: UIVideoEditorController,
                              didSaveEditedVideoToPath editedVideoPath: String) {
        print("✅ videoEditorController:didSaveEditedVideoToPath: ĐƯỢC GỌI!")
        print("📍 Edited video path:", editedVideoPath)
        
        let editedURL = URL(fileURLWithPath: editedVideoPath)
        
        // Lưu video đã edit
        showLoading(true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                try VideoManager.shared.saveVideo(at: editedURL)
                print("✅ Đã lưu video vào Documents")
                
                DispatchQueue.main.async {
                    self?.showLoading(false)
                    editor.dismiss(animated: true) {
                        self?.showAlert(title: "Thành công",
                                       message: "Video đã được lưu sau khi chỉnh sửa")
                        self?.cleanupTempVideo()
                    }
                }
            } catch {
                print("❌ Lỗi lưu video:", error)
                DispatchQueue.main.async {
                    self?.showLoading(false)
                    editor.dismiss(animated: true) {
                        self?.showAlert(title: "Lỗi",
                                       message: "Không thể lưu video: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
        print("❌ User cancelled editor")
        editor.dismiss(animated: true) { [weak self] in
            self?.cleanupTempVideo()
        }
    }
    
    func videoEditorController(_ editor: UIVideoEditorController,
                              didFailWithError error: Error) {
        print("❌ Video editor failed với error:", error)
        editor.dismiss(animated: true) { [weak self] in
            self?.showAlert(title: "Lỗi chỉnh sửa",
                           message: error.localizedDescription)
            self?.cleanupTempVideo()
        }
    }
    
    // MARK: - Helper Methods
    private func saveVideoDirectly(from url: URL) {
        showLoading(true)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                try VideoManager.shared.saveVideo(at: url)
                print("✅ Đã lưu video trực tiếp")
                
                DispatchQueue.main.async {
                    self?.showLoading(false)
                    self?.showAlert(title: "Thành công",
                                   message: "Video đã được lưu (không cần chỉnh sửa)")
                    self?.cleanupTempVideo()
                }
            } catch {
                print("❌ Lỗi lưu video trực tiếp:", error)
                DispatchQueue.main.async {
                    self?.showLoading(false)
                    self?.showAlert(title: "Lỗi",
                                   message: "Không thể lưu video: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func cleanupTempVideo() {
        // Cleanup temp video nếu cần
        if let tempURL = tempVideoURL {
            print("🧹 Cleaning up temp video")
            try? FileManager.default.removeItem(at: tempURL)
            tempVideoURL = nil
        }
    }
    
    private func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
            selectButton.isEnabled = false
            listButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            selectButton.isEnabled = true
            listButton.isEnabled = true
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                     message: message,
                                     preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - Debug Extension
extension UploadViewControllerMobileCoreServices {
    override var debugDescription: String {
        return """
        UploadViewController Debug Info:
        - Has temp video: \(tempVideoURL != nil)
        - Is loading: \(activityIndicator.isAnimating)
        """
    }
}
