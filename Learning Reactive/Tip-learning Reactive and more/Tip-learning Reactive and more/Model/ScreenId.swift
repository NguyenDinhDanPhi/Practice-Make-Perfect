//
//  ScreenId.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 18/02/2025.
//

import Foundation


enum ScreenId {
    
    enum LogoView: String {
        case logoView
    }
    
    enum ResultView: String {
        case totalAmountPerPersonLabel
        case totalBillValueLabel
        case totalTipValueLabel
    }
    
    enum BillInputView: String {
        case textField
    }
    
    enum TipInputView: String {
        case tenPercentButton
        case fifteenPercentButton
        case twentyPercentButton
        case customTipButton
        case customTipAlertTextField
    }
    
    enum SplitInputView: String {
        case decrementButton
        case inrementButton
        case quantityLabel
    }
}
