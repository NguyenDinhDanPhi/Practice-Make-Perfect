//
//  VerifyStreamerViewController.swift
//  demoVNID
//
//  Created by Dan Phi on 9/9/25.
//

import UIKit

class BecomeStreamerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trở thành streamer FangTV"
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "streamerIcon"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var titleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(iconImageView)
        return view
    }()

    // 👉 tableView cũng khai báo kiểu lazy var như label
    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dataSource = self
        tv.delegate = self
        tv.separatorStyle = .none
        tv.register(BecomeStreamerCell.self, forCellReuseIdentifier: BecomeStreamerCell.reuseID)
        return tv
    }()
    
    private var items: [VerifyItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home livestream"
        
        setupLayout()
        loadData()
    }
    
    private func setupLayout() {
        view.addSubview(titleView)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            
            iconImageView.topAnchor.constraint(equalTo: titleView.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            iconImageView.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
            iconImageView.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadData() {
        // mock data (sau này thay bằng API)
        items = [
            VerifyItem(icon: UIImage(systemName: "calendar"),
                       title: "Tài khoản đã đăng ký ít nhất 30 ngày",
                       accessory: .checkmarkGreen),
            VerifyItem(icon: UIImage(named: "vneid"),
                       title: "Xác thực VNeID",
                       accessory: .statusPill(text: "Chưa xác thực",
                                              bg: .systemRed,
                                              textColor: .white,
                                              showChevron: true))
        ]
        tableView.reloadData()
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BecomeStreamerCell.reuseID, for: indexPath) as! BecomeStreamerCell
        cell.configure(with: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}
