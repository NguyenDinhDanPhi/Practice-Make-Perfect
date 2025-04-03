//
//  DropdownMenuViewController.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//

import UIKit

class DropdownMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let options = ["Option 1", "Option 2", "Option 3", "Option 4"]
    
    private var dropdownVisible = false
    private var button: UIButton!
    private var transparentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Tạo và thêm nút dropdown
        button = UIButton(type: .system)
        button.setTitle("Show Dropdown", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 150, height: 50)
        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        button.backgroundColor = .orange
        view.addSubview(button)
        
        // Tạo UITableView cho dropdown
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 100, y: 150, width: 200, height: 0)  // Ẩn ban đầu
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.isHidden = true  // Ẩn dropdown lúc đầu
        
        view.addSubview(tableView)
        
        // Tạo transparent view để dismiss khi chạm ra ngoài
        transparentView = UIView(frame: view.bounds)
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        transparentView.isHidden = true
        transparentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDropdown)))
        view.addSubview(transparentView)
    }

    @objc func toggleDropdown() {
        dropdownVisible.toggle()
        tableView.isHidden = !dropdownVisible
        transparentView.isHidden = !dropdownVisible
        
        // Tăng hoặc giảm chiều cao của table view
        UIView.animate(withDuration: 0.3) {
            self.tableView.frame.size.height = self.dropdownVisible ? 200 : 0
        }
    }
    
    @objc func dismissDropdown() {
        dropdownVisible = false
        tableView.isHidden = true
        transparentView.isHidden = true
    }

    // MARK: - TableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = options[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = options[indexPath.row]
        button.setTitle(selectedOption, for: .normal)
        dismissDropdown()
    }
}
