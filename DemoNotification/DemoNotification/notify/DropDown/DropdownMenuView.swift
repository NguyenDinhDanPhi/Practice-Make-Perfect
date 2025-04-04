import UIKit

class DropdownMenuView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    var removeDropdown: (() -> Void)?
    var didSelectOption: ((Int) -> Void)?
    var selectedIndex = 0
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
    
     let items = [
        ("Tất cả hoạt động", "bell.fill"),
        ("LIVE & VOD", "tv.fill"),
        ("Bình luận & Chat", "text.bubble.fill"),
        ("Tương tác", "flame.fill")
    ]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        print("hehe \(selectedIndex)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        addSubview(tableView)
        addSubview(transparentView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 224)
        ])
        
        NSLayoutConstraint.activate([
            transparentView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            transparentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            transparentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            transparentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideTableView))
        transparentView.addGestureRecognizer(tapGesture)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(DropdownCell.self, forCellReuseIdentifier: "DropdownCell")
    }
    
    func addTableView(frames: CGRect) {
        transparentView.isHidden = false
        
        tableView.transform = CGAffineTransform(translationX: 0, y: -20)
        tableView.alpha = 0
        tableView.isHidden = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 224)
        ])
        
        UIView.animate(withDuration: 0.8,
                          delay: 0,
                          usingSpringWithDamping: 0.8,
                          initialSpringVelocity: 0.5,
                          options: [.curveEaseOut],
                          animations: {
               self.tableView.transform = .identity
               self.tableView.alpha = 1
           }, completion: nil)
    }
    
    @objc private func hideTableView() {
        removeDropdown?()
    }
    
    // MARK: - TableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownCell", for: indexPath) as! DropdownCell
        let (title, iconName) = items[indexPath.row]
        
        cell.configure(title: title, iconName: iconName, selected: indexPath.row == selectedIndex)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.row]
        selectedIndex = indexPath.row
        didSelectOption?(indexPath.row)
        tableView.reloadData()
        removeDropdown?()
        hideTableView()
    }
}
