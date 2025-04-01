//
//  ViewController.swift
//  DemoDragtoDeleteCell
//
//  Created by dan phi on 1/4/25.
//

import DropDown

class ViewController: UIViewController {
    let dropDown = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Thiết lập các items cho dropdown
        dropDown.dataSource = ["Option 1", "Option 2", "Option 3"]
        
        // Tạo button để hiển thị dropdown
        let button = UIButton(type: .system)
        button.setTitle("Show Dropdown", for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        view.addSubview(button)
        
        // Hiển thị dropdown khi button được nhấn
        button.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
    }

    @objc func showDropDown() {
        // Vị trí hiển thị của dropdown (sẽ xuất hiện dưới button)
        dropDown.anchorView = view.subviews.first // view chứa button
        
        // Hiển thị dropdown
        dropDown.show()
        
        // Xử lý khi chọn một item trong dropdown
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
        }
    }
}
