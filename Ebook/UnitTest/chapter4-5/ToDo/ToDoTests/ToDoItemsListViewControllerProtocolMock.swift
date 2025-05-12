//
//  ToDoItemsListViewControllerProtocolMock.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import UIKit
@testable import ToDo

class ToDoItemsListViewControllerProtocolMock: ToDoItemsListViewControllerProtocol {
    var selectToDoItemReceivedArguments:(viewController: UIViewController, item: ToDoItem)?
    
    func selectToDoItem(_ viewController: UIViewController, toDoItem: ToDo.ToDoItem) {
        selectToDoItemReceivedArguments = (viewController: viewController, item: toDoItem)
    }
    
    
}
