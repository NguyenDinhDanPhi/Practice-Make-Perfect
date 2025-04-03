import UIKit

class DropdownMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Option", for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(onShowTableViewButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
        
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tableViewButton.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 224)
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
    @objc func onShowTableViewButtonPressed(_ sender: UITapGestureRecognizer) {
        addTableView(frames: tableViewButton.frame)
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
        tableViewButton.setTitle(selectedItem.0, for: .normal)  // Cập nhật nút với mục đã chọn
        hideTableView()
    }
}
