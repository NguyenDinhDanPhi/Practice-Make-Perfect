//
//  CurrencyFormatterTest.swift
//  BankeyUnitTests
//
//  Created by dan phi on 29/01/2025.
//

import XCTest
@testable import Bankey

class Test: XCTestCase {
    
    var formatter: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
}
