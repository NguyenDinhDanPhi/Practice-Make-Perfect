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
    //LogoVIew
    var logoView: XCUIElement {
        return app.otherElements[ScreenId.LogoView.logoView.rawValue]
    }
    
    //ResultView
    
    var totalAmountPerPersonValueLabel: XCUIElement {
        return app.staticTexts[ScreenId.ResultView.totalAmountPerPersonLabel.rawValue]
    }
    var totalBillValueLabel: XCUIElement {
        return app.staticTexts[ScreenId.ResultView.totalBillValueLabel.rawValue]
    }
    var totalTipValueLabel: XCUIElement {
        return app.staticTexts[ScreenId.ResultView.totalTipValueLabel.rawValue]
    }
    
    //BillInputView
    var billInPuttextField:  XCUIElement {
        return app.textFields[ScreenId.BillInputView.textField.rawValue]
    }
    
    // TipInputView
    var tenPercentTipButton: XCUIElement {
        return app.buttons[ScreenId.TipInputView.tenPercentButton.rawValue]
    }
    
    var fifteenPercentTipButton: XCUIElement {
        return app.buttons[ScreenId.TipInputView.fifteenPercentButton.rawValue]
    }
    
    var twentyPercentTipButton: XCUIElement {
        return app.buttons[ScreenId.TipInputView.twentyPercentButton.rawValue]
    }
    
    var customTipButton: XCUIElement {
        return app.buttons[ScreenId.TipInputView.customTipButton.rawValue]
    }
    var customTipAlertButton: XCUIElement {
        return app.textFields[ScreenId.TipInputView.customTipAlertTextField.rawValue]
    }
    
    //SplitInputView
    var decrementButton: XCUIElement {
        return app.buttons[ScreenId.SplitInputView.decrementButton.rawValue]

    }
    
    var inrementButton: XCUIElement {
        return app.buttons[ScreenId.SplitInputView.inrementButton.rawValue]

    }
    
    var quantityLabel: XCUIElement {
        return app.staticTexts[ScreenId.SplitInputView.quantityLabel.rawValue]
    }
    //action
    
    func enterBill(amount: Double) {
        billInPuttextField.tap()
        billInPuttextField.typeText("\(amount)\n")
    }
    
    func selectTip(tip: Tip) {
        switch tip {
        case .tenPercent:
            tenPercentTipButton.tap()
        case .fiftenPercent:
            fifteenPercentTipButton.tap()
        case .twentyPercent:
            twentyPercentTipButton.tap()
        case .custom(let value):
            customTipButton.tap()
            XCTAssertTrue(customTipAlertButton.waitForExistence(timeout: 1.0))
            customTipAlertButton.typeText("\(value)\n")
        }
    }
    func selectDecrementButton(numberTap: Int) {
        decrementButton.tap(withNumberOfTaps: numberTap, numberOfTouches: 1)
    }
    func selectInrementButton(numberTap: Int) {
        inrementButton.tap(withNumberOfTaps: numberTap, numberOfTouches: 1)
    }
    func doubleTapLogoView() {
      logoView.tap(withNumberOfTaps: 2, numberOfTouches: 1)
    }
}

enum Tip {
    case tenPercent
    case fiftenPercent
    case twentyPercent
    case custom(value: Int)
}
