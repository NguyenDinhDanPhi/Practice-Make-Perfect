import UIKit
import Combine
class NotificationViewController: UIViewController {
    
    // MARK: - UI Elements
    private var viewModel = NotificationViewModel()
    private var cancellables = Set<AnyCancellable>()
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onShowTableViewButtonPressed))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
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
    
    private lazy var loadingView: NotificationsSkeletonListView = {
        let view = NotificationsSkeletonListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emptyNotificationView: EmptyNotificationView = {
        let view = EmptyNotificationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var noLoginView: NoLoginView = {
        let view = NoLoginView()
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
    
    var isLoading: Bool = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTitleButton()
        dropdown.removeDropdown = { [weak self] in
            self?.dropdown.removeFromSuperview()
        }
        notificationViewType = .haveNotification
        setUpActionSubVIew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notifiListView.tableView.reloadData()
        viewModel.loadNotificationListFromFile()
        biding()
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
        [emptyNotificationView, emptyStateContainerView, noLoginView, notifiListView].forEach {
            $0.removeFromSuperview()
        }
        
        switch notificationViewType {
        case .emptyNotification:
            titleStackView.isHidden = false
            tickButton.isHidden = false
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
            view.addSubview(noLoginView)
            NSLayoutConstraint.activate([
                noLoginView.topAnchor.constraint(equalTo: view.topAnchor),
                noLoginView.leftAnchor.constraint(equalTo: view.leftAnchor),
                noLoginView.rightAnchor.constraint(equalTo: view.rightAnchor),
                noLoginView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            
        case .haveNotification:
            titleStackView.isHidden = false
            tickButton.isHidden = false
            view.addSubview(notifiListView)
            NSLayoutConstraint.activate([
                notifiListView.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 8),
                notifiListView.leftAnchor.constraint(equalTo: view.leftAnchor),
                notifiListView.rightAnchor.constraint(equalTo: view.rightAnchor),
                notifiListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        case .loading:
            view.addSubview(loadingView)
            NSLayoutConstraint.activate([
                loadingView.topAnchor.constraint(equalTo: titleButton.bottomAnchor, constant: 8),
                loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
                loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
                loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        case .none:
            break
        }
    }
    
    // MARK: - Dropdown Action
    
    @objc private func onShowTableViewButtonPressed() {
        let container = view.window!
        
        if dropdown.superview == nil {
            container.addSubview(dropdown)
            dropdown.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                dropdown.topAnchor.constraint(equalTo: titleButton.bottomAnchor),
                dropdown.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                dropdown.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                dropdown.bottomAnchor.constraint(equalTo: container.bottomAnchor)
            ])

            dropdown.isHidden = false
            dropdown.addTableView(frames: titleButton.frame)
        } else {
            dropdown.removeFromSuperview()
        }
    }
    
    func setUpActionSubVIew() {
        noLoginView.singupAction = { [weak self] in
            print("haha")
        }
    }
    
    // MARK: - Simulate API

    func fetchNotifications() {
            self.isLoading = false
            self.notificationViewType = .emptyNotification
            
            // Hoặc khi có dữ liệu
            // self.notifiListView.update(with: data)
            // self.notificationViewType = .haveNotification
            
            // Hoặc lỗi
            // self.notificationViewType = .errorNotification
        
    }
    
    @objc private func tickButtonTapped() {
        for i in 0..<notifiListView.todayNotis.count {
           // notifiListView.todayNotis[i].isSelected = true
        }
        
        for i in 0..<notifiListView.earlierNotis.count {
           // notifiListView.earlierNotis[i].isSelected = true
        }
        
        notifiListView.tableView.reloadData()
    }
    
    func biding() {
        viewModel.$inboxNotices
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notice in
                if let inboxNotices = notice?.data {
                    self?.notifiListView.configure(inboxList: inboxNotices)
                }
                
            }
            .store(in: &cancellables)
    }

}

// MARK: - Enum

enum NotificationViewType {
    case emptyNotification, errorNotification, notLogin, haveNotification, loading
}
