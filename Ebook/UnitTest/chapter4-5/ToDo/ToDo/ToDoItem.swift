//
//  ToDoItem.swift
//  ToDo
//
//  Created by dan phi on 20/4/25.
//
import Foundation

struct ToDoItem {
    let title: String
    let itemDescription: String?
    let timestamp: TimeInterval?
    
    init(title: String,
         itemDescription: String? = nil,
         timestamp: TimeInterval? = nil) {
        self.title = title
       self.itemDescription = itemDescription
        self.timestamp = timestamp
    }
}
