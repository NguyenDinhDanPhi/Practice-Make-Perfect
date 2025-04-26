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
    func add(_ item: ToDoItem) {
        items.append(item)
    }
}

