//
//  ToDoItemDetailsViewControllerTests.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import XCTest
@testable import ToDo

class ToDoItemDetailsViewControllerTests: XCTestCase {
    
    var sut: ToDoItemDetailsViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "ToDoItemDetailsViewController") as! ToDoItemDetailsViewController
        
        sut.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_view_shouldHaveTitleLabel() throws {
        let subView = try XCTUnwrap(sut.titleLabel)
        XCTAssertTrue(subView.isDescendant(of: sut.view))
    }
    
    func test_view_shouldHaveDateLabel() throws {
        let subview = try XCTUnwrap(sut.dateLabel)
        XCTAssertTrue(subview.isDescendant(of: sut.view))
    }
    
    func test_view_shouldHaveLocationLabel() throws {
        let subview = try XCTUnwrap(sut.locationLabel)
        XCTAssertTrue(subview.isDescendant(of: sut.view))
    }
    
    func test_view_shouldHaveDescriptionLabel() throws {
        let subview = try XCTUnwrap(sut.descriptionLabel)
        XCTAssertTrue(subview.isDescendant(of: sut.view))
    }
    
    func test_view_shouldHaveMapView() throws {
        let subview = try XCTUnwrap(sut.mapView)
        XCTAssertTrue(subview.isDescendant(of: sut.view))
    }
    
    func test_view_shouldHaveDoneButton() throws {
        let subview = try XCTUnwrap(sut.doneButton)
        XCTAssertTrue(subview.isDescendant(of: sut.view))
    }
    
    func test_settingTodoItem_shouldUpdateTitleLabe() {
        let title = "Dummy title"
        let todoItem = ToDoItem(title: title)
        sut.toDoItem = todoItem
        XCTAssertEqual(sut.titleLabel.text, title)
    }
    
    func test_settingTodoItem_shouldUpdateDateLabel() {
        let date = Date()
        let todoItem = ToDoItem(title: "Dummy title", timestamp: date.timeIntervalSince1970)
        sut.toDoItem = todoItem
        
        XCTAssertEqual(sut.dateLabel.text,
                       sut.dateFormatter.string(from: date))
    }
    
    func test_settingToDoItem_shouldUpdateDescriptionLabel() {
        let description = "dummy discription"
        let toDoItem = ToDoItem(
            title: "dummy title",
            itemDescription: description)
        sut.toDoItem = toDoItem
        XCTAssertEqual(sut.descriptionLabel.text, description)
    }
    
    func test_settingToDoItem_shouldUpdateLocationLabel() {
        let location = "dummy location"
        let toDoItem = ToDoItem(
            title: "dummy title",
            location: Location(name: location))
        sut.toDoItem = toDoItem
        XCTAssertEqual(sut.locationLabel.text, location)
    }
    
    func test_settingToDoItem_shouldUpdateMapView() {
        let latitude = 51.225556
        let longitude = 6.782778
        let toDoItem = ToDoItem(
            title: "dummy title",
            location: Location(
                name: "dummy location",
                coordinate: Coordinate(latitude: latitude,
                                       longitude: longitude)))
        sut.toDoItem = toDoItem
        let center = sut.mapView.centerCoordinate
        XCTAssertEqual(center.latitude,
                       latitude,
                       accuracy: 0.000_01)
        XCTAssertEqual(center.longitude,longitude,
                       accuracy: 0.000_01)
    }
    
    func test_settingToDoItem_shouldUpdateButtonState() {
        var toDoItem = ToDoItem(title: "dummy title")
        toDoItem.done = true
        sut.toDoItem = toDoItem
        XCTAssertFalse(sut.doneButton.isEnabled)
    }
    
    func test_settingToDoItem_whenItemNotDone_shouldUpdateButtonState() {
        let toDoItem = ToDoItem(title: "dummy title")
        sut.toDoItem = toDoItem
        XCTAssertTrue(sut.doneButton.isEnabled)
    }
}
