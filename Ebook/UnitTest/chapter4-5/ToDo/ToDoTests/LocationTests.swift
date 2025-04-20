//
//  LocationTests.swift
//  ToDo
//
//  Created by dan phi on 20/4/25.
//

import XCTest
@testable import ToDo
import CoreLocation

class LocationTests: XCTestCase {
    
    func test_init_setsCoordinate() throws {
        let coordinate = CLLocationCoordinate2D(latitude: 1,
                                                longitude: 2)
        let location = Location(name: "",
                                coordinate: coordinate)
        let resultCoordinate = try XCTUnwrap(location.coordinate)
        XCTAssertEqual(resultCoordinate.latitude, 1,
                       accuracy: 0.000_001)
        XCTAssertEqual(resultCoordinate.longitude, 2,
                       accuracy: 0.000_001)
    }
    
    func test_init_setsName() {
        let location = Location(name: "Dummy")
        XCTAssertEqual(location.name, "Dummy")
    }
}
