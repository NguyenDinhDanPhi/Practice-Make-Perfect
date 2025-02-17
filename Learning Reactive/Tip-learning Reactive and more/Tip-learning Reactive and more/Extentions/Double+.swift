//
//  Double+.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 17/02/2025.
//

import Foundation
extension Double {
    var currencyFormatter: String {
        var isWholeNumber: Bool {
            isZero ? true : !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? ""
    }
}
