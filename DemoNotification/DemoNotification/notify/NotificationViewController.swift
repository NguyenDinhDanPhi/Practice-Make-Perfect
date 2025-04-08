import UIKit

class NotificationViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var titleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tất cả hoạt động", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onShowTableViewButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_arrow_down")?.withRenderingMode(.alwaysTemplate))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleButton, arrowImageView])
        view.backgroundColor = .clear
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tickButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        let image = UIImage(named: "checkStatus")?.withTintColor(.black)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tickButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var dropdown: DropdownMenuView = {
        let view = DropdownMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var notifiListView: NotificationsListView = {
        let view = NotificationsListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyNotificationView: EmptyNotificationView = {
        let view = EmptyNotificationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var notificationNotLoginView: NotificationNotLoginView = {
        let view = NotificationNotLoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyStateContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - State
    
    var notificationViewType: NotificationViewType? {
        didSet {
            updateNotificationUI()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notification"
        setupTitleButton()
        dropdown.removeDropdown = { [weak self] in
            self?.dropdown.removeFromSuperview()
        }
        notifiListView.loading = true
        notificationViewType = .notLogin
        fetchNotifications()
        setUpActionSubVIew()
    }

    // MARK: - Setup
    
    private func setupTitleButton() {
        view.addSubview(titleStackView)
        view.addSubview(tickButton)
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tickButton.topAnchor.constraint(equalTo: titleButton.topAnchor),
            tickButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tickButton.widthAnchor.constraint(equalToConstant: 34),
            tickButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        dropdown.didSelectOption = { [weak self] index in
            guard let self = self else { return }
            let title = self.dropdown.items[index].0
            self.titleButton.setTitle("\(title)", for: .normal)
        }
    }
    
    private func updateNotificationUI() {
        [emptyNotificationView, emptyStateContainerView, notificationNotLoginView, notifiListView].forEach {
            $0.removeFromSuperview()
        }
        
        switch notificationViewType {
        case .emptyNotification:
            view.addSubview(emptyNotificationView)
            NSLayoutConstraint.activate([
                emptyNotificationView.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 8),
                emptyNotificationView.leftAnchor.constraint(equalTo: view.leftAnchor),
                emptyNotificationView.rightAnchor.constraint(equalTo: view.rightAnchor),
                emptyNotificationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
        case .errorNotification:
            titleStackView.isHidden = true
            tickButton.isHidden = true
            view.addSubview(emptyStateContainerView)
            NSLayoutConstraint.activate([
                emptyStateContainerView.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 8),
                emptyStateContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                emptyStateContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                emptyStateContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
            let data = EmptyStateViewData(
                numberOfButtons: .oneButton,
                titleText: "Không Thể tải danh sách thông báo",
                subtitleText: "vui lòng thử lại",
                imageDetails: "empy",
                textRetryButton: "tải lại",
                textBackButton: "",
                textExistButton: ""
            )
            
            let emptyStateVC = EmptyStateViewController.createEmptyStateViewController(data: data)
            emptyStateVC.addToParentViewController(self, in: emptyStateContainerView)
            
            emptyStateVC.onRetryAction = { [weak self] in
                self?.fetchNotifications()
            }
            
        case .notLogin:
            titleStackView.isHidden = true
            tickButton.isHidden = true
            view.addSubview(notificationNotLoginView)
            NSLayoutConstraint.activate([
                notificationNotLoginView.topAnchor.constraint(equalTo: view.topAnchor),
                notificationNotLoginView.leftAnchor.constraint(equalTo: view.leftAnchor),
                notificationNotLoginView.rightAnchor.constraint(equalTo: view.rightAnchor),
                notificationNotLoginView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
        case .haveNotification:
            view.addSubview(notifiListView)
            NSLayoutConstraint.activate([
                notifiListView.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 8),
                notifiListView.leftAnchor.constraint(equalTo: view.leftAnchor),
                notifiListView.rightAnchor.constraint(equalTo: view.rightAnchor),
                notifiListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
        case .none:
            break
        }
    }
    
    // MARK: - Dropdown Action
    
    @objc private func onShowTableViewButtonPressed() {
        if dropdown.superview == nil {
            view.addSubview(dropdown)
            NSLayoutConstraint.activate([
                dropdown.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 8),
                dropdown.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                dropdown.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                dropdown.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            dropdown.isHidden = false
            dropdown.addTableView(frames: titleButton.frame)
        } else {
            dropdown.isHidden = true
            dropdown.removeFromSuperview()
        }
    }
    
    func setUpActionSubVIew() {
        notificationNotLoginView.singupAction = { [weak self] in
            print("haha")
        }
    }
    
    // MARK: - Simulate API

    func fetchNotifications() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.notifiListView.loading = false
            self.notificationViewType = .errorNotification
            
            // Hoặc khi có dữ liệu
            // self.notifiListView.update(with: data)
            // self.notificationViewType = .haveNotification
            
            // Hoặc lỗi
            // self.notificationViewType = .errorNotification
        }
    }
    
    @objc private func tickButtonTapped() {
        for i in 0..<notifiListView.todayNotis.count {
            notifiListView.todayNotis[i].isSelected = true
        }
        
        for i in 0..<notifiListView.earlierNotis.count {
            notifiListView.earlierNotis[i].isSelected = true
        }
        
        notifiListView.tableView.reloadData()
    }

}

// MARK: - Enum

enum NotificationViewType {
    case emptyNotification, errorNotification, notLogin, haveNotification
}
