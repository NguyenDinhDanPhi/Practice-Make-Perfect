//
//  AccountSummaryViewControllerTest.swift
//  BankeyUnitTests
//
//  Created by dan phi on 07/02/2025.
//

import XCTest
@testable import Bankey

class AccountSummaryViewControllerTest: XCTestCase {
    var vc: AccountSummaryViewController!
    
    override func setUp() {
        super.setUp()
        vc = AccountSummaryViewController()
        vc.loadViewIfNeeded()
    }
    
    func testShouldBeVisible() throws {
        let isViewLoaded = vc.isViewLoaded
        XCTAssertTrue(isViewLoaded)
    }
}
