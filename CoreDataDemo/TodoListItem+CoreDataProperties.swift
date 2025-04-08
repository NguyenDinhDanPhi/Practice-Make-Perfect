//
//  TodoListItem+CoreDataProperties.swift
//  CoreDataDemo
//
//  Created by dan phi on 12/03/2025.
//
//

import Foundation
import CoreData


extension TodoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListItem> {
        return NSFetchRequest<TodoListItem>(entityName: "TodoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createAt: Date?

}

extension TodoListItem : Identifiable {

}
