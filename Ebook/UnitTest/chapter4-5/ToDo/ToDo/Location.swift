//
//  Location.swift
//  ToDo
//
//  Created by dan phi on 20/4/25.
//
import CoreLocation
import Foundation

struct Location {
    let name: String
    let coordinate: CLLocationCoordinate2D?
    init(name: String,
         coordinate: CLLocationCoordinate2D? = nil) {
        self.name = name
        self.coordinate = coordinate
    }
}
