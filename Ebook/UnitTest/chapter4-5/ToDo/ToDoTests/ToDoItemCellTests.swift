//
//  ToDoItemCellTests.swift
//  ToDo
//
//  Created by Dan Phi on 12/5/25.
//

import XCTest
@testable import ToDo

class ToDoItemCellTests: XCTestCase {
    var sut: ToDoItemCell!
    override func setUpWithError() throws {
        sut = ToDoItemCell()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_hasTitleLabelSubview() {
        let subviews = sut.titleLabel
        XCTAssertTrue(subviews.isDescendant(of: sut.contentView))
    }
    
    func test_hasDateLABELSubview() {
        let subviews = sut.dateLabel
        XCTAssertTrue(subviews.isDescendant(of: sut.contentView))
    }
    
    func test_hasLocationLabelSubview() {
        let subview = sut.locationLabel
        XCTAssertTrue(subview.isDescendant(of: sut.contentView))
    }
    
    
}
