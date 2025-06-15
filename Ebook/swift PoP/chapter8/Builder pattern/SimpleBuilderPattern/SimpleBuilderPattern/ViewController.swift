//
//  ViewController.swift
//  SimpleBuilderPattern
//
//  Created by dan phi on 11/6/25.
//

import UIKit

import UIKit

class ViewController: UIViewController {

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Xây Dựng Burger Của Bạn!"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Nhập tên Burger (ví dụ: Burger đặc biệt của Jon)"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        return tf
    }()

    private lazy var pattiesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Số miếng thịt: 1"
        label.font = .systemFont(ofSize: 18)
        return label
    }()

    private lazy var pattiesStepper: UIStepper = {
        let stepper = UIStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        stepper.maximumValue = 4
        stepper.value = 1
        stepper.addTarget(self, action: #selector(pattiesStepperChanged), for: .valueChanged)
        return stepper
    }()

    private lazy var toppingsStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    private lazy var baconSwitch = createToppingSwitch(title: "Thịt xông khói")
    private lazy var cheeseSwitch = createToppingSwitch(title: "Phô mai")
    private lazy var picklesSwitch = createToppingSwitch(title: "Dưa chuột muối")
    private lazy var ketchupSwitch = createToppingSwitch(title: "Sốt cà chua")
    private lazy var mustardSwitch = createToppingSwitch(title: "Mù tạt")
    private lazy var lettuceSwitch = createToppingSwitch(title: "Xà lách")
    private lazy var tomatoSwitch = createToppingSwitch(title: "Cà chua")

    private lazy var buildButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Xây Dựng Burger", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buildBurgerButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Burger của bạn sẽ hiển thị ở đây!"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.textAlignment = .left
        label.backgroundColor = .systemGray6
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(pattiesLabel)
        view.addSubview(pattiesStepper)
        view.addSubview(toppingsStackView)
        view.addSubview(buildButton)
        view.addSubview(resultLabel)

        toppingsStackView.addArrangedSubview(baconSwitch)
        toppingsStackView.addArrangedSubview(cheeseSwitch)
        toppingsStackView.addArrangedSubview(picklesSwitch)
        toppingsStackView.addArrangedSubview(ketchupSwitch)
        toppingsStackView.addArrangedSubview(mustardSwitch)
        toppingsStackView.addArrangedSubview(lettuceSwitch)
        toppingsStackView.addArrangedSubview(tomatoSwitch)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),

            pattiesLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            pattiesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            pattiesStepper.centerYAnchor.constraint(equalTo: pattiesLabel.centerYAnchor),
            pattiesStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            toppingsStackView.topAnchor.constraint(equalTo: pattiesLabel.bottomAnchor, constant: 20),
            toppingsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toppingsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            buildButton.topAnchor.constraint(equalTo: toppingsStackView.bottomAnchor, constant: 30),
            buildButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            buildButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            buildButton.heightAnchor.constraint(equalToConstant: 55),

            resultLabel.topAnchor.constraint(equalTo: buildButton.bottomAnchor, constant: 30),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            resultLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // Helper để tạo các UISwitch cho topping
    private func createToppingSwitch(title: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 17)

        let uiSwitch = UISwitch()
        uiSwitch.translatesAutoresizingMaskIntoConstraints = false
        uiSwitch.setContentHuggingPriority(.defaultHigh, for: .horizontal) // Giữ switch không bị co giãn

        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(uiSwitch)

        return stackView
    }

    // MARK: - Actions

    @objc private func pattiesStepperChanged() {
        pattiesLabel.text = "Số miếng thịt: \(Int(pattiesStepper.value))"
    }

    @objc private func buildBurgerButtonTapped() {
        // Khởi tạo BurgerBuilder
        var builder = BurgerBuilder()

        // 1. Cài đặt Tên Burger
        if let burgerName = nameTextField.text, !burgerName.isEmpty {
            builder = builder.withName(burgerName)
        } else {
            builder = builder.withName("Burger Tùy Chỉnh") // Tên mặc định nếu không nhập
        }

        // 2. Cài đặt Số lượng miếng thịt
        builder = builder.withPatties(Int(pattiesStepper.value))

        // 3. Cài đặt các Topping dựa trên trạng thái của UISwitch
        // Chúng ta có thể dùng chaining vì các phương thức add... trả về self
        builder = builder
            .addBacon((baconSwitch.arrangedSubviews.last as! UISwitch).isOn)
            .addCheese((cheeseSwitch.arrangedSubviews.last as! UISwitch).isOn)
            .addPickles((picklesSwitch.arrangedSubviews.last as! UISwitch).isOn)
            .addKetchup((ketchupSwitch.arrangedSubviews.last as! UISwitch).isOn)
            .addMustard((mustardSwitch.arrangedSubviews.last as! UISwitch).isOn)
            .addLettuce((lettuceSwitch.arrangedSubviews.last as! UISwitch).isOn)
            .addTomato((tomatoSwitch.arrangedSubviews.last as! UISwitch).isOn)

        // 4. Xây dựng đối tượng Burger cuối cùng
        let myBurger = builder.build()

        // 5. Hiển thị thông tin Burger trên resultLabel
        resultLabel.text = myBurger.description()
        resultLabel.textAlignment = .left // Chỉnh lại căn lề sau khi có nội dung
    }
}
