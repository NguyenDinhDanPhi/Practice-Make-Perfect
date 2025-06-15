//
//  ToDoItemStoreProtocolMock.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import Foundation
import Combine
@testable import ToDo

class ToDoItemStoreProtocolMock: ToDoItemStoreProtocol {
    var itemPublisher = CurrentValueSubject<[ToDoItem], Never>([])
    
    var checkLastCallArguments: ToDoItem?
    
    func check(_ item: ToDoItem) {
        checkLastCallArguments = item
    }
}
