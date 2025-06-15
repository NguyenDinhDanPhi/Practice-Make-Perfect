//
//  Hotel.swift
//  QuickTrip - SimpleApp FacadePattern
//
//  Created by dan phi on 15/6/25.
//
import UIKit

struct Hotel {
    let name: String
    let price: Double
}

class HotelBooking {
    func searchHotel(at destination: String, date: Date, completion: @escaping (Hotel) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let result = Hotel(name: "UIKit Inn", price: 85.0)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
