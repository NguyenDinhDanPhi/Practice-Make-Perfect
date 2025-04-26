//
//  ToDoItemStoreTests.swift
//  ToDo
//
//  Created by Dan Phi on 26/4/25.
//

import XCTest
import Combine
@testable import ToDo

class ToDoItemStoreTests: XCTestCase {
    
    func test_add_shouldPublishChange() {
        let sut = ToDoItemStore()
        let publisherExpectation = expectation(description: "wait for publisher expectation")
        var receivedItems: [ToDoItem] = []
        
        let token = sut.itemPublisher
            .dropFirst()
            .sink { items in
                receivedItems = items
                publisherExpectation.fulfill()
            }
        let todoItem = ToDoItem(title: "Dummy")
        sut.add(todoItem)
        wait(for: [publisherExpectation], timeout: 1)
        token.cancel()
        
        XCTAssertEqual(receivedItems.first?.title,
                       todoItem.title)
        
        
        
    }
}
