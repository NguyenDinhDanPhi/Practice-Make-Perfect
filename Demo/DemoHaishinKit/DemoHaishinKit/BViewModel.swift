//
//  BViewModel.swift
//  DemoHaishinKit
//
//  Created by dan phi on 12/6/25.
//

import Foundation

class BViewModel {
    var data: [String] = [] // dữ liệu giả định

    func fetchData(completion: @escaping (Bool) -> Void) {
        // Ví dụ gọi API giả lập delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // Giả lập có hoặc không có data
            let success = Bool.random() // thử: true/false ngẫu nhiên

            if success {
                self.data = ["Item 1", "Item 2"]
                completion(true)
            } else {
                self.data = []
                completion(false)
            }
        }
    }
}
