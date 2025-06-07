//
//  TwoDRobotMover.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

class TwoDRobotMover: RobotMovement {
    func forward(speedPercent: Double) {
        print("2D Robot moving forward at \(speedPercent)% speed.")
    }
    
    func reverse(speedPercent: Double) {
        print("2D Robot moving reverse at \(speedPercent)% speed.")
    }
    
    func left(speedPercent: Double) {
        print("2D Robot moving left at \(speedPercent)% speed.")
    }
    
    func right(speedPercent: Double) {
        print("2D Robot moving right at \(speedPercent)% speed.")
    }
    
    func stop() {
        print("2D Robot moving stop")
    }
    
    
}
