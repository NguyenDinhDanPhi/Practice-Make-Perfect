import UIKit

class DropdownMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    private let transparentView = UIView()
    private let dataSource = ["Option 1", "Option 2", "Option 3", "Option 4"]
    private var tableViewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Cài đặt button để hiển thị dropdown menu
        tableViewButton = UIButton(type: .system)
        tableViewButton.frame = CGRect(x: 100, y: 100, width: 200, height: 40)
        tableViewButton.setTitle("Select Option", for: .normal)
        tableViewButton.addTarget(self, action: #selector(onShowTableViewButtonPressed), for: .touchUpInside)
        view.addSubview(tableViewButton)

        // Khởi tạo UITableView cho dropdown menu
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 5
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.layer.borderWidth = 1.0
        tableView.isHidden = true
        view.addSubview(tableView)
        
        // Cài đặt transparent view
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.frame = view.bounds
        transparentView.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        transparentView.addGestureRecognizer(tapGesture)
        view.addSubview(transparentView)
    }
    
    // Tạo và cài đặt UITableView
    func addTableView(frames: CGRect) {
        transparentView.isHidden = false
        transparentView.frame = self.view.frame
        
        // Tính chiều cao cho dropdown menu
        let tableViewHeight = (dataSource.count > 3) ? 120.0 : CGFloat(dataSource.count) * 40
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: tableViewHeight)
        self.view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 5
        tableView.separatorStyle = .none
        tableView.layer.borderColor = UIColor.systemGray5.cgColor
        tableView.layer.borderWidth = 1.0
        
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
        tableViewButton.setTitle(dataSource[0], for: .normal)
        
        // Thêm gesture cho transparent view để ẩn bảng khi người dùng nhấn ra ngoài
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        transparentView.addGestureRecognizer(tapGesture)
        
        tableView.isHidden = false
        transparentView.isHidden = false
    }
    
    // Phương thức để hiển thị dropdown menu
    private func showTableView(frames: CGRect) {
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: tableView.frame.height)
        tableView.isHidden = false
        transparentView.isHidden = false
    }
    
    // Phương thức để ẩn dropdown menu khi người dùng nhấn ra ngoài
    @objc private func hideTableView() {
        tableView.isHidden = true
        transparentView.isHidden = true
    }
    
    // Khi nhấn vào nút, sẽ hiển thị dropdown menu
    @objc func onShowTableViewButtonPressed(_ sender: UIButton) {
        addTableView(frames: sender.frame)
    }
    
    // MARK: - TableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableViewButton.setTitle(dataSource[indexPath.row], for: .normal)
        hideTableView()
    }
}
