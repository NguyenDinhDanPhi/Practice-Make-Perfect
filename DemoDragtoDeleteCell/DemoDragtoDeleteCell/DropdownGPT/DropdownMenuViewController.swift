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
        dropdownMenu.backgroundColor = view.backgroundColor // Set màu nền trùng với viewController
        view.addSubview(dropdownMenu)

        NSLayoutConstraint.activate([
            dropdownMenu.topAnchor.constraint(equalTo: dropdownButton.bottomAnchor, constant: 0),
            dropdownMenu.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            dropdownMenu.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
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

        if isMenuVisible {
            dropdownMenu.isHidden = false
            dropdownMenu.frame.size.height = 0  // Bắt đầu chiều cao của menu là 0
            dropdownMenu.alpha = 0  // Đặt độ mờ ban đầu thành 0 (ẩn menu)

            UIView.animate(withDuration: 0.3, animations: {
                self.dropdownMenu.frame.size.height = 220  // Cuộn xuống chiều cao đầy đủ
                self.dropdownMenu.alpha = 1  // Làm menu trở nên rõ ràng
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.dropdownMenu.frame.size.height = 0  // Cuộn lên chiều cao 0
                self.dropdownMenu.alpha = 0  // Làm menu mờ dần đi
            }) { _ in
                self.dropdownMenu.isHidden = true  // Ẩn menu sau khi cuộn lên
            }
        }
    }


}
