import UIKit
import ESPullToRefresh
struct NotificationItem {
    let title: String
    let time: Date
    let profileImage: UIImage?
    let overlayImage: UIImage?
    let thumbnailImage: UIImage?
    var isSelected: Bool = false
}

class NotificationsListView: UIView, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()

    var todayNotis: [NotificationItem] = []
    var earlierNotis: [NotificationItem] = []
    
    var loading: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        loadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotifiCell.self, forCellReuseIdentifier: NotifiCell.identifier)
        tableView.register(NotifiSkeletonCell.self, forCellReuseIdentifier: NotifiSkeletonCell.identifier)

        tableView.separatorStyle = .none
        tableView.rowHeight = 104
        tableView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        //pull to refresh
        tableView.es.addPullToRefresh {
            [weak self] in
            self?.refreshData()
        }
    }
    
    private func refreshData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.loadData()
            self.tableView.es.stopPullToRefresh()
        }
        print("haha")
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

extension NotificationsListView {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return loading ? 1 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if loading { return 7 }
        return section == 0 ? todayNotis.count : earlierNotis.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loading {
               let cell = tableView.dequeueReusableCell(withIdentifier: NotifiSkeletonCell.identifier, for: indexPath) as! NotifiSkeletonCell
            cell.showAnimatedGradientSkeleton()
            
               return cell
           }

           guard let cell = tableView.dequeueReusableCell(withIdentifier: NotifiCell.identifier, for: indexPath) as? NotifiCell else {
               return UITableViewCell()
           }

           let item = indexPath.section == 0 ? todayNotis[indexPath.row] : earlierNotis[indexPath.row]
            cell.contentView.backgroundColor = item.isSelected ? .white : UIColor(red: 1.0, green: 0.99, blue: 0.94, alpha: 1.0)
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
        if loading {
            return nil
        }
        let notiList = section == 0 ? todayNotis : earlierNotis
        return notiList.isEmpty ? nil : (section == 0 ? "Hôm nay" : "Trước đó")
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if loading { return 0 }
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
