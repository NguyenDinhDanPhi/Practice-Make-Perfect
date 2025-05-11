//
//  ToDoItemStore.swift
//  ToDo
//
//  Created by Dan Phi on 26/4/25.
//


import Foundation
import Combine

class ToDoItemStore {
    var itemPublisher =
    CurrentValueSubject<[ToDoItem], Never>([])
    private var items: [ToDoItem] = [] {
        didSet {
            itemPublisher.send(items)
        }
    }
    private let fileName: String
    
    init(fileName: String = "todoitem") {
        self.fileName = fileName
        loadItems()
    }
    func add(_ item: ToDoItem) {
        items.append(item)
        saveItems()
    }
    
    func check(_ item: ToDoItem) {
        var mutableItem = item
        mutableItem.done = true
        if let index = items.firstIndex(of: item) {
            items[index] = mutableItem
        }
    }
    
    private func saveItems() {
        let url = FileManager.default
            .documentsURL(name: fileName)
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: url)
        } catch {
            print("error: \(error)")
        }
    }
    
    func loadItems() {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName) {
            do {
                let data = try Data(contentsOf: url)
                items = try JSONDecoder().decode([ToDoItem].self, from: data)
            } catch {
                print("error \(error)")
            }
        }
        
    }
}

