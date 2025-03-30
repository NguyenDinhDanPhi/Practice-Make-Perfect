//
//  ViewController.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 30/3/25.
//

import UIKit

class NotifiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var activities: [String] = [
        "Saian, Tram Nguyen và 3 người khác thích bình luận của bạn",
        "Long Non VN thích bình luận của bạn",
        "LoL Esports VN đã trả lời bình luận của bạn",
        "LoL Esports VN thích bình luận của bạn"
    ]
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        
        table.register(NotifiCell.self, forCellReuseIdentifier: "NotifiCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotifiCell", for: indexPath) as! NotifiCell
       // cell.configure(with: activities[indexPath.row])
        cell.configure(profileImage: UIImage(named: "avatar"), overlayImage: UIImage(named: "avatar2") ,title: activities[indexPath.row], time: "3 ngày trước", thumbnail: UIImage(named: "thum"))
        return cell
    }
    
    // MARK: - Swipe to Delete
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Xóa") { _, _, completionHandler in
            self.activities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 104
    }

}

