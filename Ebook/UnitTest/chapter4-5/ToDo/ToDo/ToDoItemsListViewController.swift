//
//  ToDoItemsListViewController.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import UIKit
import Combine

protocol ToDoItemsListViewControllerProtocol {
    func selectToDoItem(_ viewController: UIViewController, toDoItem: ToDoItem)
}

class ToDoItemsListViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    var toDoItemStore: ToDoItemStoreProtocol?
    private var items: [ToDoItem] = []
    private var token: AnyCancellable?
    let dateFormatter = DateFormatter()
    private var dataSource: UITableViewDiffableDataSource<Section, ToDoItem>?
    
    enum Section {
        case todo
        case done
    }
    
    var delegate: ToDoItemsListViewControllerProtocol?
    
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
        tableView.delegate = self
        tableView.register(ToDoItemCell.self, forCellReuseIdentifier: "ToDoItemCell")
    }
    
    private func update(with items: [ToDoItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ToDoItem>()
        snapshot.appendSections([.todo, .done])
        
        snapshot.appendItems(
        items.filter({ false == $0.done }), toSection: .todo)
        
        snapshot.appendItems(
        items.filter({ $0.done }),toSection: .done)
        
        dataSource?.apply(snapshot)
    }
}

extension ToDoItemsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.selectToDoItem(self, toDoItem: item)
    }
}

