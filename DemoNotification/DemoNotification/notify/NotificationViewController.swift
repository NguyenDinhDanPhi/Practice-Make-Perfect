import UIKit

class NotificationViewController: UIViewController {
    
    private lazy var titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tất cả hoạt động", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onShowTableViewButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var dropdown: DropdownMenuView = {
        let view = DropdownMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true  // Đặt mặc định là ẩn
        return view
    }()
    
    private lazy var notifiListView: NotificationsListView = {
        let view = NotificationsListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notification"
        setUpView()
        dropdown.removeDropdown = { [weak self] in
            self?.dropdown.removeFromSuperview()  // Loại bỏ dropdown
        }
    }
    
    func setUpView() {
        view.addSubview(titleButton)
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        view.addSubview(notifiListView)
        
        NSLayoutConstraint.activate([
            notifiListView.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant:  8),
            notifiListView.leftAnchor.constraint(equalTo: view.leftAnchor),
            notifiListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            notifiListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
//        // Dữ liệu cho EmptyStateView
//        let data = EmptyStateViewData(numberOfButtons: .oneButton,
//                                      titleText: "Không Thể tải danh sách thông báo",
//                                      subtitleText: "vui lòng thử lại",
//                                      imageDetails: "empy",
//                                      textRetryButton: "tải lại", textBackButton: "", textExistButton: "")
//        
//        let emptyStateVC = EmptyStateViewController.createEmptyStateViewController(data: data)
//        emptyStateVC.addToParentViewController(self, in: notifiListView)
//        
//        emptyStateVC.onRetryAction  = { [weak self] in
//            print("Retrying...")
//        }
        
        dropdown.didSelectOption = { [weak self] index in
            guard let self = self else { return }
            let title = self.dropdown.items[index].0
            self.titleButton.setTitle("\(title) ⌄", for: .normal)
            //   self.toggleMenu()
        }
    }
    
    @objc func onShowTableViewButtonPressed() {
        if dropdown.superview == nil {
            // Nếu DropdownMenuView chưa được thêm vào view, ta thêm vào
            view.addSubview(dropdown)
            
            // Cài đặt Auto Layout cho DropdownMenuView khi thêm vào view
            NSLayoutConstraint.activate([
                dropdown.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 8),
                dropdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                dropdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                dropdown.bottomAnchor.constraint(equalTo: view.bottomAnchor )
            ])
            
            // Hiển thị dropdown
            dropdown.isHidden = false
            dropdown.addTableView(frames: titleButton.frame)
        } else {
            // Nếu DropdownMenuView đã có trong view, ta sẽ loại bỏ nó
            dropdown.isHidden = true
            dropdown.removeFromSuperview()
        }    }
}
