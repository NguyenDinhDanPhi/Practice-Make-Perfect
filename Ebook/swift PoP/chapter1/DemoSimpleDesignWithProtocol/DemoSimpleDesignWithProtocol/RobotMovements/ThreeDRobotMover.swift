//
//  ThreeDRobotMover.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//
import Foundation

class ThreeDRobotMover: RobotMovementThreeDimensions {
    func forward(speedPercent: Double) { print("3D Robot moving forward at \(speedPercent)% speed.") }
        func reverse(speedPercent: Double) { print("3D Robot moving reverse at \(speedPercent)% speed.") }
        func left(speedPercent: Double) { print("3D Robot turning left at \(speedPercent)% speed.") }
        func right(speedPercent: Double) { print("3D Robot turning right at \(speedPercent)% speed.") }
        func stop() { print("3D Robot stopped.") }
        func up(speedPercent: Double) { print("3D Robot moving up at \(speedPercent)% speed.") }
        func down(speedPercent: Double) { print("3D Robot moving down at \(speedPercent)% speed.") }
    
}
