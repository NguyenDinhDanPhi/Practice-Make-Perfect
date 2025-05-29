//
//  NotificationsSkeletonListView.swift
//  DemoNotification
//
//  Created by Dan Phi on 10/4/25.
//


import UIKit

class NotificationsSkeletonListView: UIView, UITableViewDelegate, UITableViewDataSource {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(NotifiSkeletonCell.self, forCellReuseIdentifier: NotifiSkeletonCell.identifier)
        table.separatorStyle = .none
        table.rowHeight = 104
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }

    // MARK: - TableView

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7 // hoặc bao nhiêu skeleton cell bạn muốn
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotifiSkeletonCell.identifier, for: indexPath) as? NotifiSkeletonCell else {
            return UITableViewCell()
        }
        cell.showAnimatedGradientSkeleton()
        return cell
    }
}
