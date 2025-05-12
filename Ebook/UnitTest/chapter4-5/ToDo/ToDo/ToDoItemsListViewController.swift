//
//  ToDoItemsListViewController.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import UIKit
import Combine
class ToDoItemsListViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    var toDoItemStore: ToDoItemStoreProtocol?
    private var items: [ToDoItem] = []
    private var token: AnyCancellable?
    let dateFormatter = DateFormatter()
    private var dataSource: UITableViewDiffableDataSource<Section, ToDoItem>?
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = UITableViewDiffableDataSource<Section, ToDoItem>(
            tableView: tableView,
            cellProvider: { [weak self] tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "ToDoItemCell",
                    for: indexPath
                ) as! ToDoItemCell
                cell.titleLabel.text = item.title
                if let timestamp = item.timestamp {
                    let date = Date(timeIntervalSince1970: timestamp)
                    cell.dateLabel.text = self?.dateFormatter
                        .string(from: date)
                }
                return cell
            })
        token = toDoItemStore?.itemPublisher
            .sink(receiveValue: { [weak self] items in
                self?.items = items
                self?.update(with: items)
            })
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "ToDoItemCell")
    }
    
    private func update(with items: [ToDoItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ToDoItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
    }
}

//extension ToDoItemsListViewController: UITableViewDataSource {
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            return items.count
//        }
//        
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemCell
//            let item = items[indexPath.row]
//            if let timestamp = items[indexPath.row].timestamp {
//                let date = Date(timeIntervalSince1970: timestamp)
//                cell.dateLabel.text = dateFormatter.string(from: date)
//            }
//            cell.titleLabel.text = item.title
//            return cell
//        }
//        
//    }
