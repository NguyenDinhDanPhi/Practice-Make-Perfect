//
//  BasicSensor.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

class BasicSensor: Sensor {
    var sensorType: String
    
    var sensorName: String
    
    required init(sensorName: String) {
        self.sensorName = sensorName
        self.sensorType = "BasicSensor"
        print("Sensor '\(sensorName)' of type '\(sensorType)' initialized.")

    }
    
    func pollSensor() {
        print("\(sensorName) (Type: \(sensorType)) is polling data.")
    }
    
    
}
