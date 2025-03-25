//
//  ViewController.swift
//  DemoRepord
//
//  Created by dan phi on 25/3/25.
//

import UIKit
import SkeletonView

class ViewController: UIViewController {
    var reasons: [String] = []
    var isLoading = true  // Trạng thái loading

    var selectedIndex: Int? = nil
    let tableView = UITableView()
    let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Bắt đầu hiển thị skeleton khi chưa có dữ liệu
        tableView.showAnimatedGradientSkeleton()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isLoading = false
            self.reasons = [
                "Nội dung giả mạo, lừa đảo hoặc lừa gạt",
                "Nội dung khiêu dâm hoặc nhạy cảm",
                "Nội dung bạo lực hoặc hành vi tàn ác",
                "Nội dung lăng mạ hoặc kích động thù hận",
                "Nội dung quấy rối hoặc nguy hiểm",
                "Thông tin sai lệch",
                "Nội dung không phù hợp/ ngược đãi/ lạm dụng trẻ vị thành niên"
            ]
            self.tableView.hideSkeleton()
            self.tableView.reloadData()
        }
    }

    func setupUI() {
        view.backgroundColor = .white
        title = "Báo cáo nội dung"
        
        // Setup TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isSkeletonable = true
        tableView.register(ReportCell.self, forCellReuseIdentifier: "ReportCell")
        tableView.register(ReportSkeletonCell.self, forCellReuseIdentifier: "ReportSkeletonCell")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        // Setup Send Button
        sendButton.setTitle("Gửi", for: .normal)
        sendButton.isEnabled = false
        sendButton.backgroundColor = .lightGray
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendReport), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)

        // Layout
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendButton.topAnchor, constant: -10),

            sendButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func sendReport() {
        if let index = selectedIndex {
            print("Báo cáo: \(reasons[index])")
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 7 : reasons.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportSkeletonCell", for: indexPath) as! ReportSkeletonCell
            cell.showAnimatedGradientSkeleton()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
            cell.reasonLabel.text = reasons[indexPath.row]
            cell.radioImageView.image = UIImage(named: selectedIndex == indexPath.row ? "checked" : "dont-check")
            cell.hideSkeleton()
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        sendButton.isEnabled = true
        sendButton.backgroundColor = .systemBlue
        tableView.reloadData()
    }
}
