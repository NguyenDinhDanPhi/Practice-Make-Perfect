import UIKit

class DropdownMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Option", for: .normal)
        button.addTarget(self, action: #selector(onShowTableViewButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.layer.cornerRadius = 5
        table.layer.borderColor = UIColor.systemGray5.cgColor
        table.layer.borderWidth = 1.0
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private var transparentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Thêm các thành phần vào view chính
        view.addSubview(tableViewButton)
        view.addSubview(tableView)
        view.addSubview(transparentView)
        
        // Cài đặt Auto Layout cho tableViewButton
        NSLayoutConstraint.activate([
            tableViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableViewButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            tableViewButton.widthAnchor.constraint(equalToConstant: 200),
            tableViewButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Cài đặt Auto Layout cho tableView
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 120) // Đặt chiều cao mặc định
        ])
        
        // Cài đặt Auto Layout cho transparentView
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: view.topAnchor),
            transparentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
        
        // Tính toán chiều cao cho dropdown menu
        let tableViewHeight = (items.count > 3) ? 120.0 : CGFloat(items.count) * 40
        
        // Đặt lại vị trí và kích thước cho tableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: frames.origin.x),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -frames.origin.x),
            tableView.heightAnchor.constraint(equalToConstant: tableViewHeight)
        ])
        
        tableView.isHidden = false
        tableViewButton.setTitle(items[0].0, for: .normal) // Đặt nút bằng mục đầu tiên trong mảng items
    }
    
    private func showTableView(frames: CGRect) {
        tableView.isHidden = false
        transparentView.isHidden = false
    }
    
    // Ẩn bảng khi nhấn ngoài
    @objc private func hideTableView() {
        tableView.isHidden = true
        transparentView.isHidden = true
    }
    
    // Hiển thị dropdown khi nhấn vào nút
    @objc func onShowTableViewButtonPressed(_ sender: UIButton) {
        addTableView(frames: sender.frame)
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
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        tableViewButton.setTitle(selectedItem.0, for: .normal)  // Cập nhật nút với mục đã chọn
        hideTableView()
    }
}
