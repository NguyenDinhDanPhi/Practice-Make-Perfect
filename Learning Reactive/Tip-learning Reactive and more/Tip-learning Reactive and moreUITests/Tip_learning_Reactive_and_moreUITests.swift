//
//  Tip_learning_Reactive_and_moreUITests.swift
//  Tip-learning Reactive and moreUITests
//
//  Created by dan phi on 13/02/2025.
//

import XCTest

final class Tip_learning_Reactive_and_moreUITests: XCTestCase {
    private var app: XCUIApplication!
    
    private var screen: CalculatorScreen {
        CalculatorScreen(app: app)
    }
    
    override func setUp() {
        super.setUp()
        app = .init()
        app.launch()
    }
    
    func testResultViewDefaultValues() {
        XCTAssertEqual(screen.totalAmountPerPersonValueLabel.label, "$0")
        XCTAssertEqual(screen.totalTipValueLabel.label, "$0")
        XCTAssertEqual(screen.totalBillValueLabel.label, "$0")
    }
}
