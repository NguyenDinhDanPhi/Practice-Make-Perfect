//
//  Robot.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

class MyRobot: Robot {
    var name: String
    var robotMovement: any RobotMovement
    
    private(set) var sensors: [Sensor] = [] // Mảng này chứa các đối tượng tuân thủ protocol Sensor

    required init(name: String, robotMovement: any RobotMovement) {
        self.name = name
        self.robotMovement = robotMovement
        print("Robot '\(name)' with \(type(of: robotMovement)) movement initialized.")
    }
    
    func addSensor(sensor: any Sensor) {
        sensors.append(sensor)
        print("Added sensor '\(sensor.sensorName)' (Type: \(sensor.sensorType)) to \(name).")

    }
    
    func pollSensors() {
           print("\n--- Polling sensors for \(name) ---")
           if sensors.isEmpty {
               print("No sensors attached.")
               return
           }
           for sensor in sensors {
               sensor.pollSensor() // Gọi phương thức pollSensor trên từng cảm biến
           }
           print("--- End polling for \(name) ---\n")
       }
    
    
}
