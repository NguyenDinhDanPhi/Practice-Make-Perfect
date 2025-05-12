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
    var toDoItemStoreMock: ToDoItemStoreProtocolMock!
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = try XCTUnwrap(storyboard.instantiateInitialViewController() as? ToDoItemsListViewController)
        toDoItemStoreMock = ToDoItemStoreProtocolMock()
        sut.toDoItemStore = toDoItemStoreMock
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
        toDoItemStoreMock.itemPublisher.send([ToDoItem(title: "dummy 1"), ToDoItem(title: "dummy 2")])
        let result = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(result, 2)
    }
    
    func test_cellForRowAt_shouldReturnCellWithTitle() throws {
        let titleUnderTest = "dummy 1"
        toDoItemStoreMock.itemPublisher.send([ToDoItem(title: titleUnderTest)])
        let tableView = try XCTUnwrap(sut.tableView)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = try XCTUnwrap(tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as? ToDoItemCell)
        
        XCTAssertEqual(cell.titleLabel.text, titleUnderTest)
    }
    
    func test_cellForRowAt_shouldReturnCellWithTitile2() throws {
        let titleUnderTest = "dummy 2"
        toDoItemStoreMock.itemPublisher
            .send([
                ToDoItem(title: "dummy 1"),
                ToDoItem(title: titleUnderTest)
            ])
        let tableView = try XCTUnwrap(sut.tableView)
        
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = try XCTUnwrap(
            tableView.dataSource?
                .tableView(tableView,
                           cellForRowAt: indexPath)as? ToDoItemCell
        )
        XCTAssertEqual(cell.titleLabel.text, titleUnderTest)
    }
    
    func test_cellForRowAt_shouldReturnCellWithDate() throws {
        let date = Date()
        toDoItemStoreMock.itemPublisher.send([ToDoItem(title: "dummy 1", timestamp: date.timeIntervalSince1970)])
        let tableView = try XCTUnwrap(sut.tableView)
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = try XCTUnwrap(tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath) as? ToDoItemCell)
        
        XCTAssertEqual(cell.dateLabel.text, sut.dateFormatter.string(from: date))
    }
    
    func test_numberOfSections_shouldReturnTwo() {
        var doneItem = ToDoItem(title: "dummy 2")
        doneItem.done = true
        toDoItemStoreMock.itemPublisher.send([ToDoItem(title: "dummy 1"), doneItem])
        let result = sut.tableView.numberOfSections
        XCTAssertEqual(result, 2)
        
        
    }
    
    func test_didSelectCellAt_shouldCallDelegate() throws {
        let delegateMock = ToDoItemsListViewControllerProtocolMock()
        sut.delegate = delegateMock
        let toDoItem = ToDoItem(title: "dummy 1")
        toDoItemStoreMock.itemPublisher.send([toDoItem])
        let tableView = try XCTUnwrap(sut.tableView)
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        
        XCTAssertEqual(delegateMock.selectToDoItemReceivedArguments?.item, toDoItem)
    }
}
