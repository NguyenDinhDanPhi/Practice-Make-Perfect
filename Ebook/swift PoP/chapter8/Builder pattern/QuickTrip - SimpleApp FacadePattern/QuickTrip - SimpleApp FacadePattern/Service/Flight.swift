//
//  Flight.swift
//  QuickTrip - SimpleApp FacadePattern
//
//  Created by dan phi on 15/6/25.
//
import UIKit

struct Flight {
    let airline: String
    let price: Double
}


class FlightBooking {
    func searchFlight(to destination: String, date: Date, completion: @escaping (Flight) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let result = Flight(airline: "SwiftAir", price: 120.0)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
