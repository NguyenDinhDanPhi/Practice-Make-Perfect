//
//  ToDoItemTests.swift
//  ToDo
//
//  Created by dan phi on 20/4/25.
//

import XCTest
@testable import ToDo

final class ToDoItemTests: XCTestCase {
    
    func test_init_takesTitle() {
        let item = ToDoItem(title: "Dummy")
        XCTAssertNotNil(item, "item should not be nil" )
    }
    
    func test_init_takesTitleAndDescription() {
    _ = ToDoItem(title: "Dummy",
    itemDescription: "Dummy Description")
    }
    
    func test_init_whenGivenTitle_setTitile() {
        let item = ToDoItem(title: "Dummy")
        XCTAssertEqual(item.title, "Dummy")
    }
    
    func test_init_whenGivenDescription_setsDescription() {
        let item = ToDoItem(title: "Dummy",
                            itemDescription: "Dummy Description")
        XCTAssertEqual(item.itemDescription, "Dummy Description")
    }
    
    func test_init_setsTimestamp() {
        let dummyTimestamp: TimeInterval = 42.0
        let item = ToDoItem(title: "Dummy",
                            timestamp: dummyTimestamp)
        XCTAssertEqual(item.timestamp!,
        dummyTimestamp,
        accuracy: 0.000_001)    }
}
