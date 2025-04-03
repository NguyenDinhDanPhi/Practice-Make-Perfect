import UIKit

class DropdownMenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    private var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Data source cho dropdown menu
    private let items = [
        ("Tất cả hoạt động", "bell.fill"),
        ("LIVE & VOD", "tv.fill"),
        ("Bình luận & Chat", "text.bubble.fill"),
        ("Tương tác", "flame.fill")
    ]
    
    // Biến để lưu ràng buộc chiều cao tableView
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(tableView)
        addSubview(transparentView)
        
        // Cài đặt Auto Layout cho tableView
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 120) // Đặt chiều cao mặc định
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableViewHeightConstraint!
        ])
        
        // Cài đặt Auto Layout cho transparentView
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            transparentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Thêm gesture cho transparent view để ẩn bảng khi nhấn ngoài
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        transparentView.addGestureRecognizer(tapGesture)
        
        // Cài đặt tableViewDataSource và Delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // Register DropdownCell class với tableView
        tableView.register(DropdownCell.self, forCellReuseIdentifier: "DropdownCell")
    }
    
    // Tạo và cài đặt UITableView
    func addTableView(frames: CGRect) {
        transparentView.isHidden = false
        
        // Cập nhật chiều cao cho dropdown menu
        let tableViewHeight = (items.count > 3) ? 120.0 : CGFloat(items.count) * 40
        
        // Cập nhật chiều cao của tableView
        tableViewHeightConstraint?.constant = tableViewHeight
        
        // Đặt lại vị trí và kích thước cho tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        tableView.isHidden = false
    }
    
    // Ẩn bảng khi nhấn ngoài
    @objc private func hideTableView() {
        tableView.isHidden = true
        transparentView.isHidden = true
    }
    
    // MARK: - TableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        let item = items[indexPath.row]
        cell.configure(title: item.0, iconName: item.1, selected: false)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        if let homeVC = self.superview?.next as? NotificationViewController {
            homeVC.dropdown.removeFromSuperview() // Loại bỏ DropdownMenuView
              }
        hideTableView()
    }
}
