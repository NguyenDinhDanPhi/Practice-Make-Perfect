//
//  ViewController.swift
//  QuickTrip - SimpleApp FacadePattern
//
//  Created by dan phi on 15/6/25.
//


import UIKit

class ViewController: UIViewController {

    // MARK: - UI Elements
    private let destinationField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter destination"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private let planButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Plan My Trip", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Dependencies
    private let travelFacade = TravelFacade()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "QuickTrip"
        setupLayout()
        setupActions()
    }

    // MARK: - UI Setup
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [destinationField, datePicker, planButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func setupActions() {
        planButton.addTarget(self, action: #selector(planTrip), for: .touchUpInside)
    }

    // MARK: - Logic
    @objc private func planTrip() {
        guard let destination = destinationField.text, !destination.isEmpty else {
            showAlert(title: "Missing Info", message: "Please enter a destination.")
            return
        }

        planButton.isEnabled = false
        planButton.setTitle("Planning...", for: .normal)

        travelFacade.planTrip(to: destination, on: datePicker.date) { [weak self] trip in
            guard let self = self else { return }

            let message = """
            ✈️ Flight: \(trip.flight.airline) - $\(trip.flight.price)
            🏨 Hotel: \(trip.hotel.name) - $\(trip.hotel.price)
            🚗 Car: \(trip.car.company) - $\(trip.car.dailyRate)/day
            """

            self.showAlert(title: "Trip Planned!", message: message)

            self.planButton.isEnabled = true
            self.planButton.setTitle("Plan My Trip", for: .normal)
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
