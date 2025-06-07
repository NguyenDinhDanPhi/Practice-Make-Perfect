//
//  ConcreteEnvironmentSensor.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

class ConcreteEnvironmentSensor: BasicSensor, EnvironmentSensor {
    required init(sensorName: String) {
        super.init(sensorName: sensorName)
        self.sensorType = "EnviromentSensor"
    }
    func currentTemperature() -> Double {
        let temp = Double.random(in: 20.0...30.0)
        print("\(sensorName) reports Temperature: \(String(format: "%.1f", temp))°C")
        return temp
    }
    
    func currentHumidity() -> Double {
        let humidity = Double.random(in: 40.0...70.0)
        print("\(sensorName) reports Humidity: \(String(format: "%.1f", humidity))%")
        return humidity
    }
    
    override func pollSensor() {
        super.pollSensor() // Gọi phương thức của lớp cha
        _ = currentTemperature()
        _ = currentHumidity()
    }
    
}
