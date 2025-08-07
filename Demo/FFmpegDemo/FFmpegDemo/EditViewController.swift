//
//  EditViewController.swift
//  FFmpegDemo
//
//  Created by Dan Phi on 6/8/25.
//

import UIKit
import AVKit
import AVFoundation

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var currentURL: URL
    private var playerVC: AVPlayerViewController?
    
    private var isSelectingTransitionClip = false
    private var isSelectingSticker = false
    private var transitionFirstURL: URL?
    
    // Story-like action buttons
    private let backButton = UIButton(type: .system)
    private let trimButton = UIButton(type: .system)
    private let cropButton = UIButton(type: .system)
    private let textButton = UIButton(type: .system)
    private let stickerButton = UIButton(type: .system)
    private let boxButton = UIButton(type: .system)
    private let rotateButton = UIButton(type: .system)
    private let filterButton = UIButton(type: .system)
    private let transitionButton = UIButton(type: .system)
    
    init(videoURL: URL) {
        self.currentURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Story"
        view.backgroundColor = .black
        setupPlayerView()
        setupActionButtons()
    }
    
    private func setupPlayerView() {
        let player = AVPlayer(url: currentURL)
        let vc = AVPlayerViewController()
        vc.player = player
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vc.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75)
        ])
        
        player.play()
        playerVC = vc
    }
    
    private func setupActionButtons() {
        // Configure icons and buttons array
        let buttons = [backButton, trimButton, cropButton, textButton,
                       stickerButton, boxButton, rotateButton,
                       filterButton, transitionButton]
        let icons = ["chevron.backward","scissors","crop","textformat",
                     "photo","scribble","rotate.right","wand.and.stars",
                     "pencil.tip"]
        let selectors: [Selector] = [#selector(didTapBack), #selector(didTapTrim),
                                     #selector(didTapCrop), #selector(didTapText), #selector(didTapSticker),
                                     #selector(didTapBox), #selector(didTapRotate), #selector(didTapFilter),
                                     #selector(didTapTransition)]
        
        for (btn, icon) in zip(buttons, icons) {
            btn.tintColor = .white
            btn.layer.cornerRadius = 30
            btn.backgroundColor = UIColor(white: 0.1, alpha: 0.6)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.widthAnchor.constraint(equalToConstant: 30).isActive = true
            btn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        // Set images & actions
        for (i, btn) in buttons.enumerated() {
            btn.setImage(UIImage(systemName: icons[i]), for: .normal)
            btn.addTarget(self, action: selectors[i], for: .touchUpInside)
        }
        
        // Create horizontal scroll view for buttons
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Use stack view inside scroll view
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stack)
        
        // Layout scroll view
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scrollView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Layout stack inside scroll view
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10)
        ])
    }
    
    
    @objc private func didTapBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapTrim() {
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_trim_\(Date().timeIntervalSince1970).mp4")
        VideoEditService.trimVideo(
            inputURL: currentURL,
            outputURL: out,
            startTime: 0,
            duration: 10
        ) { [weak self] success, error in
            guard success else { self?.showError(error); return }
            self?.currentURL = out
            self?.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapCrop() {
        let asset = AVAsset(url: currentURL)
        guard let track = asset.tracks(withMediaType: .video).first else { return }
        let transformedSize = track.naturalSize.applying(track.preferredTransform)
        let w = Int(abs(transformedSize.width))
        let h = Int(abs(transformedSize.height))
        let side = min(w, h)
        let x = (w - side) / 2
        let y = (h - side) / 2
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_crop_\(Date().timeIntervalSince1970).mp4")
        VideoEditService.cropVideo(
            inputURL: currentURL,
            outputURL: out,
            width: side, height: side,
            x: x, y: y
        ) { [weak self] success, error in
            guard success else { self?.showError(error); return }
            self?.currentURL = out
            self?.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapText() {
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_text_\(Date().timeIntervalSince1970).mp4")
        VideoEditService.addTextOverlay(
            inputURL: currentURL,
            outputURL: out,
            text: "Hehe Boy",
            fontFile: "/System/Library/Fonts/Helvetica.ttc",
            fontSize: 28,
            fontColor: "red",
            x: 20, y: 20
        ) { [weak self] success, error in
            guard success else { self?.showError(error); return }
            self?.currentURL = out
            self?.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapSticker() {
        // Allow user to pick an image sticker from photo library
        
        isSelectingSticker = true
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapBox() {
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_box_\(Date().timeIntervalSince1970).mp4")
        VideoEditService.drawBoxOverlay(
            inputURL: currentURL,
            outputURL: out,
            x: 70, y: 50,
            width: 200, height: 100,
            color: "blue@0.5",
            thickness: 10
        ) { [weak self] success, error in
            guard success else { self?.showError(error); return }
            self?.currentURL = out
            self?.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapRotate() {
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_rotate_\(Date().timeIntervalSince1970).mp4")
        VideoEditService.rotateVideo(
            inputURL: currentURL,
            outputURL: out,
            degrees: 90
        ) { [weak self] success, error in
            guard success else { self?.showError(error); return }
            self?.currentURL = out
            self?.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapFilter() {
        let out = FileManager.default.temporaryDirectory
            .appendingPathComponent("edit_filter_\(Date().timeIntervalSince1970).mp4")
        // Example: sepia
        VideoEditService.applyColorFilter(
            inputURL: currentURL,
            outputURL: out,
            filterName: "colorchannelmixer=.393:.769:.189:0:.349:.686:.168:0:.272:.534:.131"
        ) { [weak self] success, error in
            guard success else { self?.showError(error); return }
            self?.currentURL = out
            self?.replacePlayerItem(with: out)
        }
    }
    
    @objc private func didTapTransition() {
        // Bắt đầu chọn clip thứ hai để transition
        isSelectingTransitionClip = true
        transitionFirstURL = currentURL
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.movie"]
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)

        // LƯU Ý: reset cả hai ngay khi delegate được gọi
        let wasTransition = isSelectingTransitionClip
        let wasSticker    = isSelectingSticker
        isSelectingTransitionClip = false
        isSelectingSticker       = false

        if wasTransition {
            handleTransition(info: info)
        }
        else if wasSticker {
            handleSticker(info: info)
        }
    }


        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
            isSelectingTransitionClip = false
            isSelectingSticker     = false
        }
    // MARK: – Helper
    
    private func sandboxedURL(from originalURL: URL) throws -> URL {
        // Tạo tên file tạm với UUID để tránh đụng
        let filename = "\(UUID().uuidString)_\(originalURL.lastPathComponent)"
        let dest = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: dest.path) {
            try FileManager.default.removeItem(at: dest)
        }
        try FileManager.default.copyItem(at: originalURL, to: dest)
        return dest
    }
    
    private func handleTransition(info: [UIImagePickerController.InfoKey: Any]) {
        guard
          let firstURL  = transitionFirstURL,
          let secondURL = info[.mediaURL] as? URL
        else { return }

        do {
            let a = try sandboxedURL(from: firstURL)
            let b = try sandboxedURL(from: secondURL)
            let out = FileManager.default.temporaryDirectory
                .appendingPathComponent("transition_\(UUID().uuidString).mp4")

            VideoEditService.crossfadeVideos(
                firstURL: a,
                secondURL: b,
                outputURL: out,
                duration: 2.0
            ) { [weak self] ok, err in
                guard ok else { self?.showError(err); return }
                self?.currentURL = out
                self?.replacePlayerItem(with: out)
            }
        } catch {
            showError(error)
        }
    }

    private func handleSticker(info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            showError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Không lấy được ảnh"]))
            return
        }
        let stickerFile = FileManager.default.temporaryDirectory
            .appendingPathComponent("\(UUID().uuidString)_sticker.png")
        guard let data = image.pngData() else {
            showError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "PNG data thất bại"]))
            return
        }
        do {
            try data.write(to: stickerFile)
            let videoTemp = try sandboxedURL(from: currentURL)
            let out = FileManager.default.temporaryDirectory
                .appendingPathComponent("sticker_\(UUID().uuidString).mp4")

            VideoEditService.addStickerOverlay(
                inputURL: videoTemp,
                stickerURL: stickerFile,
                outputURL: out,
                stickerWidth: 100
            ) { [weak self] ok, err in
                guard ok else { self?.showError(err); return }
                self?.currentURL = out
                self?.replacePlayerItem(with: out)
            }
        } catch {
            showError(error)
        }
    }


    private func replacePlayerItem(with url: URL) {
        DispatchQueue.main.async {
            let newItem = AVPlayerItem(url: url)
            self.playerVC?.player?.replaceCurrentItem(with: newItem)
            self.playerVC?.player?.play()
        }
    }
    
    private func showError(_ error: Error?) {
        let alert = UIAlertController(title: "Lỗi", message: error?.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
