//
//  ViewController.swift
//  DemoSimpleDesignWithProtocol
//
//  Created by dan phi on 7/6/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Elements
    // UISegmentedControl để chọn loại robot (2D hoặc 3D).
    // Lợi ích: Cung cấp tùy chọn linh hoạt cho người dùng.
    private lazy var robotTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["2D Robot", "3D Robot"])
        sc.selectedSegmentIndex = 0 // Mặc định chọn 2D
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.addTarget(self, action: #selector(robotTypeChanged), for: .valueChanged)
        return sc
    }()
    
    // Nút để thêm cảm biến vào robot.
    // Lợi ích: Giao diện trực quan để cấu hình robot.
    private lazy var addSensorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Sensor", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addSensorTapped), for: .touchUpInside)
        return button
    }()
    
    // Nút điều khiển robot di chuyển tiến.
    private lazy var moveForwardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forward", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveForward), for: .touchUpInside)
        return button
    }()
    
    // Nút điều khiển robot di chuyển lên (chỉ cho robot 3D).
    // Ban đầu ẩn, chỉ hiển thị khi robot là 3D.
    // Lợi ích: Giao diện thích ứng với khả năng của robot.
    private lazy var moveUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Up", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(moveUp), for: .touchUpInside)
        button.isHidden = true // Hidden by default for 2D robot
        return button
    }()
    
    // Nút để yêu cầu tất cả cảm biến polling dữ liệu.
    // Lợi ích: Dễ dàng mô phỏng việc đọc dữ liệu từ các cảm biến.
    private lazy var pollSensorsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Poll All Sensors", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pollAllSensors), for: .touchUpInside)
        return button
    }()
    
    // TextView để hiển thị output từ các hành động và cảm biến.
    // Lợi ích: Log các hoạt động của robot để người dùng theo dõi.
    private lazy var outputTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        tv.backgroundColor = .secondarySystemBackground
        tv.layer.cornerRadius = 8
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - Properties
    // Thuộc tính để lưu trữ đối tượng robot hiện tại.
    // Kiểu là 'Robot' (protocol), cho phép lưu trữ bất kỳ class nào tuân thủ Robot.
    // Lợi ích: Tính đa hình - có thể thay đổi loại robot mà không cần thay đổi code UI.
    var currentRobot: Robot!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        initializeRobot() // Khởi tạo robot mặc định khi app load
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Thêm các UI element vào view và thiết lập Auto Layout constraints.
        // Lợi ích: Đảm bảo giao diện hiển thị đúng trên mọi kích thước màn hình.
        view.addSubview(robotTypeSegmentedControl)
        view.addSubview(addSensorButton)
        view.addSubview(moveForwardButton)
        view.addSubview(moveUpButton)
        view.addSubview(pollSensorsButton)
        view.addSubview(outputTextView)
        
        NSLayoutConstraint.activate([
            robotTypeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            robotTypeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            robotTypeSegmentedControl.widthAnchor.constraint(equalToConstant: 250),
            
            addSensorButton.topAnchor.constraint(equalTo: robotTypeSegmentedControl.bottomAnchor, constant: 20),
            addSensorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addSensorButton.widthAnchor.constraint(equalToConstant: 200),
            addSensorButton.heightAnchor.constraint(equalToConstant: 44),
            
            moveForwardButton.topAnchor.constraint(equalTo: addSensorButton.bottomAnchor, constant: 20),
            moveForwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            moveForwardButton.widthAnchor.constraint(equalToConstant: 100),
            moveForwardButton.heightAnchor.constraint(equalToConstant: 44),
            
            moveUpButton.topAnchor.constraint(equalTo: moveForwardButton.topAnchor),
            moveUpButton.leadingAnchor.constraint(equalTo: moveForwardButton.trailingAnchor, constant: 20),
            moveUpButton.widthAnchor.constraint(equalToConstant: 100),
            moveUpButton.heightAnchor.constraint(equalToConstant: 44),
            
            pollSensorsButton.topAnchor.constraint(equalTo: moveForwardButton.bottomAnchor, constant: 20),
            pollSensorsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pollSensorsButton.widthAnchor.constraint(equalToConstant: 200),
            pollSensorsButton.heightAnchor.constraint(equalToConstant: 44),
            
            outputTextView.topAnchor.constraint(equalTo: pollSensorsButton.bottomAnchor, constant: 20),
            outputTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    // MARK: - Robot Logic
    // Hàm khởi tạo robot dựa trên lựa chọn của segmented control.
    // Lợi ích: Dễ dàng chuyển đổi giữa các loại robot khác nhau chỉ bằng cách thay đổi đối tượng robotMovement.
    private func initializeRobot() {
        if robotTypeSegmentedControl.selectedSegmentIndex == 0 {
            // Khởi tạo robot 2D với TwoDRobotMover.
            currentRobot = MyRobot(name: "Robo2D", robotMovement: TwoDRobotMover())
            moveUpButton.isHidden = true // Ẩn nút "Up"
        } else {
            // Khởi tạo robot 3D với ThreeDRobotMover.
            currentRobot = MyRobot(name: "Robo3D", robotMovement: ThreeDRobotMover())
            moveUpButton.isHidden = false // Hiển thị nút "Up"
        }
        updateOutput("Initialized \(currentRobot.name).\n")
    }
    
    // Xử lý sự kiện khi loại robot thay đổi.
    @objc private func robotTypeChanged(_ sender: UISegmentedControl) {
        initializeRobot() // Khởi tạo lại robot với loại mới
    }
    
    // Xử lý sự kiện khi nút "Add Sensor" được nhấn.
    // Hiển thị một UIAlertController để chọn loại cảm biến muốn thêm.
    // Lợi ích: Cho phép người dùng linh hoạt thêm nhiều loại cảm biến vào một robot.
    // Protocol composition (kết hợp protocol) là khả thi ở đây, ví dụ một class có thể conform nhiều sensor protocol.
    @objc private func addSensorTapped() {
        let alert = UIAlertController(title: "Add Sensor", message: "Choose a sensor type", preferredStyle: .actionSheet)
        
        // Thêm hành động cho từng loại cảm biến.
        alert.addAction(UIAlertAction(title: "Environment Sensor", style: .default, handler: { _ in
            let sensor = ConcreteEnvironmentSensor(sensorName: "EnvSensor_\(self.currentRobot.sensors.count + 1)")
            self.currentRobot.addSensor(sensor: sensor) // Thêm cảm biến vào robot
            self.updateOutput("Added Environment Sensor: \(sensor.sensorName)\n")
        }))
        
        alert.addAction(UIAlertAction(title: "Range Sensor", style: .default, handler: { _ in
            let sensor = ConcreteRangeSensor(sensorName: "RangeSensor_\(self.currentRobot.sensors.count + 1)")
            self.currentRobot.addSensor(sensor: sensor)
            // Ví dụ thiết lập notification cho RangeSensor: khi robot cách vật 50cm, sẽ có thông báo.
            sensor.setRangeNotification(rangeCentimeter: 50) {
                self.updateOutput("!!! ROBOT ALERT: Object too close via \(sensor.sensorName)!\n")
            }
            self.updateOutput("Added Range Sensor: \(sensor.sensorName)\n")
        }))
        
        alert.addAction(UIAlertAction(title: "Display Sensor", style: .default, handler: { _ in
            let sensor = ConcreteDisplaySensor(sensorName: "DisplaySensor_\(self.currentRobot.sensors.count + 1)")
            self.currentRobot.addSensor(sensor: sensor)
            self.updateOutput("Added Display Sensor: \(sensor.sensorName)\n")
            sensor.displayMessage(message: "Hello from \(sensor.sensorName)!") // Gọi trực tiếp phương thức của cảm biến
        }))
        
        alert.addAction(UIAlertAction(title: "Wireless Sensor", style: .default, handler: { _ in
            let sensor = ConcreteWirelessSensor(sensorName: "WirelessSensor_\(self.currentRobot.sensors.count + 1)")
            self.currentRobot.addSensor(sensor: sensor)
            // Ví dụ thiết lập notification cho WirelessSensor: khi nhận tin nhắn, sẽ có thông báo.
            sensor.setMessageReceivedNotification { receivedMsg in
                self.updateOutput("!!! ROBOT ALERT: Message received via \(sensor.sensorName): '\(receivedMsg)'\n")
            }
            self.updateOutput("Added Wireless Sensor: \(sensor.sensorName)\n")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func moveForward() {
        currentRobot.robotMovement.forward(speedPercent: 75) // Gọi phương thức forward của đối tượng robotMovement hiện tại.
        updateOutput("\(currentRobot.name) is moving forward.\n")
    }
    
    @objc private func moveUp() {
        if let threeDMover = currentRobot.robotMovement as? RobotMovementThreeDimensions {
            threeDMover.up(speedPercent: 50)
            updateOutput("\(currentRobot.name) is moving up.\n")
        } else {
            updateOutput("\(currentRobot.name) cannot move up (not a 3D robot).\n")
        }
    }
    
    // Xử lý sự kiện khi nút "Poll All Sensors" được nhấn.
       // Lợi ích: Triển khai một cách thống nhất việc thu thập dữ liệu từ tất cả cảm biến,
       // bất kể loại cảm biến cụ thể là gì, nhờ vào tính đa hình của protocol Sensor.
       @objc private func pollAllSensors() {
           outputTextView.text = "" // Xóa output cũ
           currentRobot.pollSensors() // Yêu cầu robot polling tất cả cảm biến của nó.
           // Các dòng print từ các cảm biến sẽ xuất hiện ở console.
           updateOutput("Polling complete. Check console for detailed sensor outputs.\n")
       }
    
    // Hàm tiện ích để thêm text vào TextView và cuộn xuống dưới cùng.
    private func updateOutput(_ text: String) {
        outputTextView.text += text
        let bottom = NSRange(location: outputTextView.text.count - 1, length: 1)
        outputTextView.scrollRangeToVisible(bottom)
    }
    
    
}

