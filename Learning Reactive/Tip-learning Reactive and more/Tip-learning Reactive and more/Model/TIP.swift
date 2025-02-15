//
//  TIP.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 15/02/2025.
//

import Foundation
enum Tip {
    case none
    case tenPercent
    case fiftenPercent
    case twentyPercent
    case custom(value: Int)
    
    var stringValue: String {
        switch self {
        case .none:
            return ""
        case .tenPercent:
            return "10%"
        case .fiftenPercent:
            return "15%"
        case .twentyPercent:
            return "20%"
        case .custom(value: let value):
            return String(value)
        }
    }
}
