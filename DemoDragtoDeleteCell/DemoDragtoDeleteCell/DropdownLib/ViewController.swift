import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dropDownButton: UIButton!
    var tableView: UITableView!
    let options = ["Tất cả hoạt động", "LIVE & VOD", "Bình luận & Chat", "Tương tác"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        dropDownButton = UIButton(type: .system)
        dropDownButton.setTitle("Tất cả hoạt động ⌄", for: .normal)
        dropDownButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        dropDownButton.setTitleColor(.black, for: .normal)
        dropDownButton.frame = CGRect(x: 50, y: 100, width: 300, height: 50)
        dropDownButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        dropDownButton.layer.cornerRadius = 10
        dropDownButton.layer.borderWidth = 1
        dropDownButton.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(dropDownButton)

        tableView = UITableView()
        tableView.frame = CGRect(x: 50, y: 150, width: 300, height: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        tableView.isHidden = true
        tableView.backgroundColor = .white
        tableView.layer.shadowColor = UIColor.black.cgColor
        tableView.layer.shadowOpacity = 0.1
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        tableView.layer.shadowRadius = 4
        tableView.register(DropDownTableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        view.addSubview(tableView)
    }

    @objc func toggleDropdown() {
        if tableView.isHidden {
            tableView.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.tableView.frame = CGRect(x: 50, y: 150, width: 300, height: CGFloat(self.options.count * 50))
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.tableView.frame = CGRect(x: 50, y: 150, width: 300, height: 0)
            }) { _ in
                self.tableView.isHidden = true
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownTableViewCell
        cell.configureCell(with: options[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownButton.setTitle(options[indexPath.row] + " ⌄", for: .normal)
        tableView.isHidden = true
    }
}
