import UIKit
import ESPullToRefresh
struct NotificationItemModel {
    let title: String
    let time: Date
    let profileImage: UIImage?
    let overlayImage: UIImage?
    let thumbnailImage: UIImage?
    var isSelected: Bool = false
}

class NotificationsListView: UIView, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(NotifiCell.self, forCellReuseIdentifier: NotifiCell.identifier)
        table.separatorStyle = .none
        table.rowHeight = 104
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    var todayNotis: [InboxNotices] = []
    var earlierNotis: [InboxNotices] = []

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
        //pull to refresh
        tableView.es.addPullToRefresh {
            [weak self] in
            self?.refreshData()
        }
    }
    
    private func refreshData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.es.stopPullToRefresh()
        }
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
        let title = item.message.title + " " + item.message.body
        let time = timeAgoString(from: Date(timeIntervalSince1970: TimeInterval(item.createdAt.timestamp)))
        let thumbnailURL = item.message.image
        let profileURL = item.attribute.from.first?.image
        cell.configure(profileImage: profileURL, overlayImage: "", title: title, time: time, thumbnail: thumbnailURL)
//            cell.contentView.backgroundColor = item.isSelected ? .white : UIColor(red: 1.0, green: 0.99, blue: 0.94, alpha: 1.0)
//           cell.configure(
//               profileImage: item.profileImage,
//               overlayImage: item.overlayImage,
//               title: item.title,
//               time: timeAgoString(from: item.time),
//               thumbnail: item.thumbnailImage,
//               hiddenRed: item.isSelected
//           )
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
//        let section = indexPath.section
//            let row = indexPath.row
//            if section == 0 {
//                todayNotis[row].isSelected = true
//            } else {
//                earlierNotis[row].isSelected = true
//            }
//            
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//        let item = indexPath.section == 0 ? todayNotis[indexPath.row] : earlierNotis[indexPath.row]
//        print("Bạn vừa chọn: \(item.title)")
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
    
    
    func configure(inboxList: [InboxNotices]) {
        let calendar = Calendar.current

        todayNotis = inboxList.filter {
            let date = Date(timeIntervalSince1970: TimeInterval($0.createdAt.timestamp))
            return calendar.isDateInToday(date)
        }

        earlierNotis = inboxList.filter {
            let date = Date(timeIntervalSince1970: TimeInterval($0.createdAt.timestamp))
            return !calendar.isDateInToday(date)
        }

        tableView.reloadData()
    }
}
