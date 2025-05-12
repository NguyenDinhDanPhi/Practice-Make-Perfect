//
//  ToDoItemsListViewControllerTests.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import XCTest
@testable import ToDo

final class ToDoItemsListViewControllerTests: XCTestCase {
    
    var sut: ToDoItemsListViewController!
    var todDoItemStoreMock: ToDoItemStoreProtocolMock!
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = try XCTUnwrap(storyboard.instantiateInitialViewController() as? ToDoItemsListViewController)
        todDoItemStoreMock = ToDoItemStoreProtocolMock()
        sut.toDoItemStore = todDoItemStoreMock
        sut.loadViewIfNeeded()
    }
    
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_shouldBeSetup() {
        XCTAssertNotNil(sut)
    }
    
    func test_shouldHaveTableView() {
        XCTAssertTrue(sut.tableView.isDescendant(of: sut.view))
    }
    
    func test_numberOfRows_whenOneItemIsSent_shouldReturnOne() {
        todDoItemStoreMock.itemPublisher.send([ToDoItem(title: "dummy 1"), ToDoItem(title: "dummy 2")])
        let result = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(result, 2)
    }
}
