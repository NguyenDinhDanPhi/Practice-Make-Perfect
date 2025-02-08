//
//  AccountSumaryHeaderViewModel.swift
//  Bankey
//
//  Created by dan phi on 01/02/2025.
//

import UIKit

struct AccountSumaryHeaderViewModel {
    let welcomeMessage: String
    let name: String
    let date: Date
    
    var dateFormat:String {
        return date.monthDayYearString
    }
}
