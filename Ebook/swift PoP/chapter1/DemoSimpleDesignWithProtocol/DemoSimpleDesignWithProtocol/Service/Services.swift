//
//  Services.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//
import Foundation

// MARK: - Robot Movement Protocols
// Đây là protocol cơ bản định nghĩa các hành động di chuyển 2 chiều (2D).
// Bất kỳ robot nào muốn di chuyển cơ bản đều phải tuân thủ protocol này.
protocol RobotMovement {
    func forward(speedPercent: Double)
    func reverse(speedPercent: Double)
    func left(speedPercent: Double)
    func right(speedPercent: Double)
    func stop()
}

// RobotMovementThreeDimensions kế thừa từ RobotMovement.
// Điều này có nghĩa là một robot 3D không chỉ di chuyển lên/xuống,
// mà nó còn phải có tất cả các khả năng di chuyển của RobotMovement.
// Lợi ích: Tái sử dụng định nghĩa, mở rộng chức năng một cách rõ ràng.
protocol RobotMovementThreeDimensions: RobotMovement {
    func up(speedPercent: Double)
    func down(speedPercent: Double)
}

// MARK: - Sensor Protocols
// Sensor là protocol cơ bản cho tất cả các loại cảm biến.
// Nó định nghĩa các thuộc tính và phương thức chung mà mọi cảm biến cần có.
// 'AnyObject' được thêm vào để cho phép 'weak references' tới delegate trong tương lai
// hoặc tránh reference cycle nếu protocol được dùng với class.
protocol Sensor: AnyObject {
    var sensorType: String {get} // Loại cảm biến (ví dụ: "DHT22EnvironmentSensor")
    var sensorName: String {get set} // Tên riêng của cảm biến (ví dụ: "RearEnvironmentSensor")
    init (sensorName: String) // Phương thức khởi tạo với tên cảm biến
    func pollSensor() // Phương thức để đọc dữ liệu từ cảm biến
}

// EnvironmentSensor kế thừa từ Sensor và thêm các yêu cầu cụ thể cho cảm biến môi trường.
// Lợi ích: Tách biệt logic, dễ dàng thêm các loại cảm biến mới.
protocol EnvironmentSensor: Sensor {
    func currentTemperature() -> Double
    func currentHumidity() -> Double
}

// RangeSensor kế thừa từ Sensor và thêm các yêu cầu cho cảm biến khoảng cách.
// Chú ý: Có một closure (hàm không tên) để thiết lập thông báo.
// Lợi ích: Cho phép robot nhận thông báo khi khoảng cách đạt ngưỡng.
protocol RangeSensor: Sensor {
    func setRangeNotification(rangeCentimeter: Double,
                              rangeNotification: @escaping () -> Void)
    func currentRange() -> Double
}

// DisplaySensor kế thừa từ Sensor và thêm yêu cầu cho cảm biến hiển thị.
// Lợi ích: Robot có thể hiển thị thông báo.
protocol DisplaySensor: Sensor {
    func displayMessage(message: String)
}

// WirelessSensor kế thừa từ Sensor và thêm yêu cầu cho cảm biến không dây.
// Lợi ích: Robot có thể gửi/nhận tin nhắn không dây.
protocol WirelessSensor: Sensor {
    func setMessageReceivedNotification(messageNotification: @escaping (String) -> Void)
    func messageSend(message: String)
}

// MARK: - Robot Protocol
// Robot là protocol định nghĩa cấu trúc tổng thể và khả năng của một robot.
// Nó bao gồm tên, khả năng di chuyển và danh sách các cảm biến.
// Lợi ích: Đảm bảo mọi robot đều có các thành phần cốt lõi này.
protocol Robot {
    var name: String {get set}
    var robotMovement: RobotMovement {get set} // Chú ý kiểu là RobotMovement, không phải loại cụ thể
    var sensors: [Sensor] {get} // Mảng các Sensor (protocol), không phải loại cụ thể
    init (name: String, robotMovement: RobotMovement)
    func addSensor(sensor: Sensor)
    func pollSensors()
}
