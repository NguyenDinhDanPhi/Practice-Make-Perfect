//
//  Untitled.swift
//  demoOnboarding
//
//  Created by Dan Phi on 16/6/25.
//
import UIKit

struct OnboardingPage {
    let image: UIImage?
    let title: String
    let description: String
}


import UIKit

class OnboardingViewController: UIViewController {
    // MARK: - Properties
    private lazy var pages: [OnboardingPageView] = {
        return [
            OnboardingPageView(image: UIImage(named: "onb1"), title: "Chào mừng", description: "Mô tả trang 1..."),
            OnboardingPageView(image: UIImage(named: "onb2"), title: "Tính năng", description: "Mô tả trang 2..."),
            OnboardingPageView(image: UIImage(named: "onb3"), title: "Bắt đầu", description: "Mô tả trang 3...")
        ]
    }()
    private var currentIndex = 0
    
    // Container để chứa page hiện tại
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()
    private let nextButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Tiếp", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        showPage(at: currentIndex, animated: false)
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        view.addSubview(nextButton)
        // Layout containerView: chiếm phần lớn view
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20),
            
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    // MARK: - Hiển thị page
    private func showPage(at index: Int, animated: Bool) {
        guard index >= 0, index < pages.count else { return }
        let newPage = pages[index]
        // Thêm newPage vào container, thiết lập frame hoặc constraints để fill container
        containerView.addSubview(newPage)
        // Dùng Auto Layout để newPage fill containerView
        NSLayoutConstraint.activate([
            newPage.topAnchor.constraint(equalTo: containerView.topAnchor),
            newPage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            newPage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            newPage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        // Cập nhật nút
        updateButtonTitle()
        if !animated {
            // Lần đầu: không cần animation, chỉ hiện sẵn
            return
        }
        // Nếu animated, phần animation đã được xử lý ở didTapNext (xem bên dưới)
    }
    
    private func updateButtonTitle() {
        if currentIndex == pages.count - 1 {
            nextButton.setTitle("Bắt đầu", for: .normal)
        } else {
            nextButton.setTitle("Tiếp", for: .normal)
        }
    }
    
    @objc private func didTapNext() {
        let nextIndex = currentIndex + 1
        if nextIndex < pages.count {
            // Slide animation: thêm nextView ở bên phải, rồi animate cả hai
            let currentView = pages[currentIndex]
            let nextView = pages[nextIndex]
            
            // Chuẩn bị nextView offscreen bên phải
            containerView.addSubview(nextView)
            // Tạm disable Auto Layout constraints fill để dùng frame-based animation. Ta cần frame đúng:
            // Đảm bảo layout hiện tại đã xong
            containerView.layoutIfNeeded()
            nextView.translatesAutoresizingMaskIntoConstraints = true
            currentView.translatesAutoresizingMaskIntoConstraints = true
            
            let width = containerView.bounds.width
            let height = containerView.bounds.height
            // Thiết lập frame ban đầu cho nextView: x = +width, y = 0
            nextView.frame = CGRect(x: width, y: 0, width: width, height: height)
            // currentView frame: assume fill container
            currentView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            // Animate slide
            UIView.animate(withDuration: 0.3, animations: {
                currentView.frame = CGRect(x: -width, y: 0, width: width, height: height)
                nextView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }, completion: { [self] _ in
                // Sau khi animation xong: remove currentView khỏi superview, và restore Auto Layout cho nextView
                currentView.removeFromSuperview()
                // restore Auto Layout constraints cho nextView
                nextView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    nextView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
                    nextView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
                    nextView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
                    nextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
                ])
                self.currentIndex = nextIndex
                // updateButtonTitle đã được gọi trong didSet nếu cần, hoặc gọi ở đây:
                self.updateButtonTitle()
            })
        } else {
            // Trang cuối: dismiss hoặc callback
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Nếu muốn hỗ trợ vuốt ngang nhưng ẩn indicator, có thể bổ sung UISwipeGestureRecognizer ở đây
}
