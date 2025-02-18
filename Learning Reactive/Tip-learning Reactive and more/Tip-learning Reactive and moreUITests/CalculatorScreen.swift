//
//  CalculatorScreen.swift
//  Tip-learning Reactive and moreUITests
//
//  Created by dan phi on 18/02/2025.
//

import XCTest
class CalculatorScreen {
    private let app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
    }
    
    var totalAmountPerPersonValueLabel: XCUIElement {
        return app.staticTexts[ScreenId.ResultView.totalAmountPerPersonLabel.rawValue]
    }
    var totalBillValueLabel: XCUIElement {
        return app.staticTexts[ScreenId.ResultView.totalBillValueLabel.rawValue]
    }
    var totalTipValueLabel: XCUIElement {
        return app.staticTexts[ScreenId.ResultView.totalTipValueLabel.rawValue]
    }
}
