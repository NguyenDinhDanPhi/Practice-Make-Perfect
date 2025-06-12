//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by dan phi on 12/03/2025.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [TodoListItem]()
    lazy var tableVIew: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableVIew)
        title = "Core data todolist"
        tableVIew.dataSource = self
        tableVIew.dataSource = self
        tableVIew.frame = view.bounds
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAdd))
    }
    @objc private func didTapAdd() {
            let alert = UIAlertController(title: "New Item",
                                          message: "Enter new item",
                                          preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            
            alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                    return
                }
                
                self?.createItem(name: text)
            }))
            
            present(alert, animated: true)
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    //MARK: Core data
    func getAllItem() {
        do {
            models = try context.fetch(TodoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableVIew.reloadData()
            }
            
        } catch {
            print("error when fetch all item")
        }
        
    }
    
    func createItem(name: String) {
        let newItem = TodoListItem(context: context)
        newItem.name = name
        newItem.createAt = Date()
        do {
            try context.save()
        } catch {
            print("error when createItem")
        }
        getAllItem()
    }
    
    func deleteItem(item: TodoListItem) {
        context.delete(item)
        do {
            try context.save()
        } catch {
            print("error when delete item")
        }
    }
    
    func updateItem(item: TodoListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
        } catch {
            print("error when update")
        }
    }
}

