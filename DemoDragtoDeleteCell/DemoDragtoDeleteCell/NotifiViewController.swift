//
//  ViewController.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 30/3/25.
//
import UIKit

struct NotificationItem {
    let title: String
    let time: Date
    let profileImage: UIImage?
    let overlayImage: UIImage?
    let thumbnailImage: UIImage?
}

class NotifiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    
    private var todayNotis: [NotificationItem] = []
    private var earlierNotis: [NotificationItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        loadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotifiCell.self, forCellReuseIdentifier: NotifiCell.identifier)
        tableView.separatorStyle = .none
        tableView.rowHeight = 104
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func loadData() {
        // Dummy data demo
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: now)!

        let noti1 = NotificationItem(
            title: "Saian, Tram Nguyen và 3 người khác thích bình luận của bạn",
            time: now,
            profileImage: UIImage(named: "avatar"),
            overlayImage: UIImage(named: "avatar2"),
            thumbnailImage: UIImage(named: "thum")
        )

        let noti2 = NotificationItem(
            title: "LoL Esports VN thích bình luận của bạn",
            time: yesterday,
            profileImage: UIImage(named: "avatar"),
            overlayImage: nil,
            thumbnailImage: UIImage(named: "thum")
        )

        let noti3 = NotificationItem(
            title: "Long Non VN thích bình luận của bạn",
            time: yesterday,
            profileImage: UIImage(named: "avatar"),
            overlayImage: nil,
            thumbnailImage: UIImage(named: "thum")
        )

        let all = [noti1, noti2, noti3]
        let calendar = Calendar.current

        todayNotis = all.filter { calendar.isDateInToday($0.time) }
        
        earlierNotis = all.filter { !calendar.isDateInToday($0.time) }

        tableView.reloadData()
    }

    // MARK: - Helper

    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

//MARK: TableView delegate

extension NotifiViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? todayNotis.count : earlierNotis.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotifiCell.identifier, for: indexPath) as? NotifiCell else {
            return UITableViewCell()
        }

        let item = indexPath.section == 0 ? todayNotis[indexPath.row] : earlierNotis[indexPath.row]

        cell.configure(
            profileImage: item.profileImage,
            overlayImage: item.overlayImage,
            title: item.title,
            time: timeAgoString(from: item.time),
            thumbnail: item.thumbnailImage
        )

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let notiList = section == 0 ? todayNotis : earlierNotis
        return notiList.isEmpty ? nil : (section == 0 ? "Hôm nay" : "Trước đó")
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let notiList = section == 0 ? todayNotis : earlierNotis
        return notiList.isEmpty ? 0 : 32
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.textColor = .black
        header.textLabel?.frame.origin.x = 16
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = indexPath.section == 0 ? todayNotis[indexPath.row] : earlierNotis[indexPath.row]
        print("Bạn vừa chọn: \(item.title)")
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            if indexPath.section == 0 {
                self.todayNotis.remove(at: indexPath.row)
            } else {
                self.earlierNotis.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completionHandler(true)
        }

        deleteAction.image = UIImage(systemName: "trash") // SFSymbol icon
        deleteAction.backgroundColor = UIColor(red: 0.92, green: 0.23, blue: 0.23, alpha: 1) // màu đỏ

        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }

}
