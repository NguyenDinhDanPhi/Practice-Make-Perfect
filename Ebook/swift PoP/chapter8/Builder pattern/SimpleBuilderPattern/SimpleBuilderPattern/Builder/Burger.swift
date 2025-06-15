
//
//  Untitled.swift
//  SimpleBuilderPattern
//
//  Created by dan phi on 11/6/25.
//

struct Burger {
    var name: String
    var patties: Int
    var bacon: Bool
    var cheese: Bool
    var pickles: Bool
    var ketchup: Bool
    var mustard: Bool
    var lettuce: Bool
    var tomato: Bool
    
    // Phương thức để hiển thị thông tin burger
    func description() -> String {
        var desc = "--- \(name) ---\n"
        desc += "Số miếng thịt: \(patties)\n"
        desc += "Thịt xông khói: \(bacon ? "Có" : "Không")\n"
        desc += "Phô mai: \(cheese ? "Có" : "Không")\n"
        desc += "Dưa chuột muối: \(pickles ? "Có" : "Không")\n"
        desc += "Sốt cà chua: \(ketchup ? "Có" : "Không")\n"
        desc += "Mù tạt: \(mustard ? "Có" : "Không")\n"
        desc += "Xà lách: \(lettuce ? "Có" : "Không")\n"
        desc += "Cà chua: \(tomato ? "Có" : "Không")\n"
        return desc
    }
}
