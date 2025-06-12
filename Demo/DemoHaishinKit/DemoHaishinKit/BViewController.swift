import UIKit

class BViewController: UIViewController {

    private let viewModel: BViewModel

    // MARK: - Init
    init(viewModel: BViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue

        let button = UIButton(type: .system)
        button.setTitle("Dismiss All", for: .normal)
        button.addTarget(self, action: #selector(dismissToRoot), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        print("📦 Dữ liệu trong B:", viewModel.data)
    }

    @objc private func dismissToRoot() {
        presentingViewController?.presentingViewController?.dismiss(animated: true)
    }
}

// BViewController.swift
extension BViewController {
    static func presentIfNeeded(from presenter: UIViewController) {
        let viewModel = BViewModel()
        viewModel.fetchData { success in
            DispatchQueue.main.async {
                guard success else {
                    print("❌ Không có dữ liệu, không present.")
                    return
                }

                let vc = BViewController(viewModel: viewModel)
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersGrabberVisible = true
                }
                presenter.present(vc, animated: true)
            }
        }
    }
}
