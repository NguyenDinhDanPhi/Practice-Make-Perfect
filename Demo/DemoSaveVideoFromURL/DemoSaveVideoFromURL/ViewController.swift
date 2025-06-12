//
//  ViewController.swift
//  DemoSaveVideoFromURL
//
//  Created by dan phi on 27/3/25.
//

import UIKit
import Photos

class ViewController: UIViewController {
    var buttonSaves: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.backgroundColor = .systemBlue
        b.setTitle("Download & Save Video", for: .normal)
        b.addTarget(self, action: #selector(tap), for: .touchUpInside)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(buttonSaves)

        NSLayoutConstraint.activate([
            buttonSaves.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonSaves.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonSaves.widthAnchor.constraint(equalToConstant: 200),
            buttonSaves.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    func downloadAndSaveVideo(from urlString: String) {
        guard let url = URL(string: urlString), isValidVideoURL(url) else {
                print("❌ URL không hợp lệ hoặc không phải video!")
                return
            }

        let task = URLSession.shared.downloadTask(with: url) { tempURL, response, error in
            guard let tempURL = tempURL, error == nil else {
                print("Download failed: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsPath.appendingPathComponent("downloadedVideo.mp4")

            // Xóa file cũ nếu đã tồn tại
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try? FileManager.default.removeItem(at: fileURL)
            }

            do {
                try FileManager.default.moveItem(at: tempURL, to: fileURL)
                print("File saved at: \(fileURL)")

                // Kiểm tra quyền lưu vào thư viện ảnh
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        PHPhotoLibrary.shared().performChanges({
                            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
                        }) { completed, error in
                            DispatchQueue.main.async {
                                if completed {
                                    print("Video is saved to Photos!")
                                } else {
                                    print("Error saving video: \(error?.localizedDescription ?? "Unknown error")")
                                }
                            }
                        }
                    } else {
                        print("Permission denied to save video!")
                    }
                }
            } catch {
                print("Error saving file: \(error.localizedDescription)")
            }
        }

        task.resume()
    }

    @objc func tap() {
        let url = "https://www.youtube.com/shorts/l-JZMCj3XjA?feature=share" // Cần thay link hợp lệ
        downloadAndSaveVideo(from: url)
    }
    
    func isValidVideoURL(_ url: URL) -> Bool {
        let videoExtensions = ["mp4", "mov", "avi", "mkv"]
        return videoExtensions.contains(url.pathExtension.lowercased())
    }
}
