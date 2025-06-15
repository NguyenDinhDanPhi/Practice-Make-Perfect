//
//  ConcreteRangeSensor.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

class ConcreteRangeSensor: BasicSensor, RangeSensor {
    
    private var notificationClosure: (() -> Void)? // Biến lưu trữ closure
    private var triggerRange: Double = 0
    
    required init(sensorName: String) {
           super.init(sensorName: sensorName)
           self.sensorType = "RangeSensor"
       }
    func setRangeNotification(rangeCentimeter: Double, rangeNotification: @escaping () -> Void) { // (1) rangeNotification là non-escaping
        self.triggerRange = rangeCentimeter
        self.notificationClosure = rangeNotification // (2) Gán non-escaping closure vào @escaping closure (self.notificationClosure)
        print("\(sensorName) range notification set for \(rangeCentimeter) cm.")
    }
    
    func currentRange() -> Double {
        let range = Double.random(in: 0...600)
        print("\(sensorName) reports Range: \(String(format: "%.1f", range)) cm.")
        
        if range <= triggerRange, let closure = self.notificationClosure {
            print("!!! \(sensorName) triggered range notification: Robot is too close!")
            closure()
        }
        return range
    }
    
    
}
