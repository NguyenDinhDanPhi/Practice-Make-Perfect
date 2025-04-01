//
//  DropdownMenuViewController.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 1/4/25.
//
import UIKit
// ViewController.swift
class DropdownMenuViewController: UIViewController {

    let dropdownButton = UIButton(type: .system)
    let dropdownMenu = DropdownMenuView()
    var isMenuVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButton()
        setupMenu()
    }

    private func setupButton() {
        dropdownButton.setTitle("Tất cả hoạt động ⌄", for: .normal)
        dropdownButton.setTitleColor(.black, for: .normal)
        dropdownButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        dropdownButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)

        view.addSubview(dropdownButton)
        dropdownButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dropdownButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dropdownButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupMenu() {
        dropdownMenu.translatesAutoresizingMaskIntoConstraints = false
        dropdownMenu.isHidden = true
        view.addSubview(dropdownMenu)

        NSLayoutConstraint.activate([
            dropdownMenu.topAnchor.constraint(equalTo: dropdownButton.bottomAnchor, constant: 0),
            dropdownMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0), // full từ trái
            dropdownMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0), // full tới phải
            dropdownMenu.heightAnchor.constraint(equalToConstant: 220)
        ])

        dropdownMenu.didSelectOption = { [weak self] index in
            guard let self = self else { return }
            let title = self.dropdownMenu.items[index].0
            self.dropdownButton.setTitle("\(title) ⌄", for: .normal)
            self.toggleMenu()
        }
    }


    @objc private func toggleMenu() {
        isMenuVisible.toggle()
        UIView.animate(withDuration: 0.2) {
            self.dropdownMenu.isHidden = !self.isMenuVisible
        }
    }
}
