//
//  Car.swift
//  QuickTrip - SimpleApp FacadePattern
//
//  Created by dan phi on 15/6/25.
//

import UIKit

struct Car {
    let company: String
    let dailyRate: Double
}

class CarRentalBooking {
    func searchCar(at destination: String, date: Date, completion: @escaping (Car) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            let result = Car(company: "DriveNow", dailyRate: 40.0)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}


