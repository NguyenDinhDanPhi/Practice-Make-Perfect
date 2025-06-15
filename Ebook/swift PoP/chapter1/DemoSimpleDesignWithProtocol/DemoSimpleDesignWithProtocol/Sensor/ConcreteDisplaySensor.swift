//
//  ConcreteDisplaySensor.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

class ConcreteDisplaySensor: BasicSensor, DisplaySensor {
    required init(sensorName: String) {
        super.init(sensorName: sensorName)
        self.sensorType = "DisplaySensor"
    }
    
    func displayMessage(message: String) {
        print("\(sensorName) displays: '\(message)'")
    }
    
    override func pollSensor() {
        super.pollSensor()
        displayMessage(message: "Status OK") // Ví dụ: hiển thị tin nhắn mặc định khi polling
    }
}
