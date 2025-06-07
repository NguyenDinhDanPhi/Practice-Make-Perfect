//
//  ConcreteWirelessSensor.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

//ConcreteWirelessSensor kế thừa BasicSensor và tuân thủ WirelessSensor.
// Nó có khả năng gửi/nhận tin nhắn không dây và thông báo khi nhận tin.
// Lợi ích: Mô phỏng khả năng giao tiếp không dây của robot.
class ConcreteWirelessSensor: BasicSensor, WirelessSensor {
    private var messageNotificationClosure: ((String) -> Void)?
    
    required init(sensorName: String) {
        super.init(sensorName: sensorName)
        self.sensorType = "WirelessSensor"
    }
    
    func setMessageReceivedNotification(messageNotification: @escaping(String) -> Void) {
        self.messageNotificationClosure = messageNotification
        print("\(sensorName) message received notification set.")
    }
    
    func messageSend(message: String) {
        print("\(sensorName) sending message: '\(message)'")
    }
    
    override func pollSensor() {
        super.pollSensor()
        // Mô phỏng việc nhận một tin nhắn ngẫu nhiên
        let messages = ["Hello from base", "Ping response", "Data packet received"]
        if let receivedMessage = messages.randomElement(), let closure = messageNotificationClosure {
            print("!!! \(sensorName) received message: '\(receivedMessage)'")
            closure(receivedMessage)
        }
    }
}
