import UIKit

class BViewController: UIViewController {
    
    private let viewModel: BViewModel
    var onPostResult: ((Bool) -> Void)? // ✅ callback trả kết quả về A
    
    private init(viewModel: BViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("\(self) is deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let postButton = UIButton(type: .system)
        postButton.setTitle("Post", for: .normal)
        postButton.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        
        postButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(postButton)
        
        NSLayoutConstraint.activate([
            postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        print("📦 Dữ liệu trong B:", viewModel.data)
    }
    
    @objc private func didTapPost() {
        viewModel.postRequest { [weak self] success in
            DispatchQueue.main.async {
                self?.dismiss(animated: true) {
                    self?.onPostResult?(success) // ✅ Gọi callback báo kết quả
                    
                }
            }
        }
    }
    
    @objc private func dismissToRoot() {
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}

extension BViewController {
    static func presentIfNeeded(
        from presenter: UIViewController,
        onPostResult: @escaping (Bool) -> Void,
        onFetchFailed: @escaping () -> Void
    ) {
        let viewModel = BViewModel()
        viewModel.fetchData { success in
            DispatchQueue.main.async {
                guard success else {
                    print("❌ Không có dữ liệu, không present.")
                    onFetchFailed() // ✅ gọi callback khi fetch fail
                    return
                }
                
                let vc = BViewController(viewModel: viewModel)
                vc.onPostResult = onPostResult
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }
                presenter.present(vc, animated: true)
            }
        }
    }
}

