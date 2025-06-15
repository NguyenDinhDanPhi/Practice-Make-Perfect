//
//  TravelFacade.swift
//  QuickTrip - SimpleApp FacadePattern
//
//  Created by dan phi on 15/6/25.
//
import UIKit
struct TripPlan {
    let flight: Flight
    let hotel: Hotel
    let car: Car
}


class TravelFacade {
    private let flightBooking = FlightBooking()
    private let hotelBooking = HotelBooking()
    private let carBooking = CarRentalBooking()

    func planTrip(to destination: String, on date: Date, completion: @escaping (TripPlan) -> Void) {
        let group = DispatchGroup()

        var flight: Flight?
        var hotel: Hotel?
        var car: Car?

        group.enter()
        flightBooking.searchFlight(to: destination, date: date) {
            flight = $0
            group.leave()
        }

        group.enter()
        hotelBooking.searchHotel(at: destination, date: date) {
            hotel = $0
            group.leave()
        }

        group.enter()
        carBooking.searchCar(at: destination, date: date) {
            car = $0
            group.leave()
        }

        group.notify(queue: .main) {
            if let f = flight, let h = hotel, let c = car {
                let plan = TripPlan(flight: f, hotel: h, car: c)
                completion(plan)
            }
        }
    }
}
