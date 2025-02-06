//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by dan phi on 27/01/2025.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    var profile: Profile?
    var headerViewModel = AccountSumaryHeaderViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    var tableView = UITableView()
    let headerView = AccountSummaryHeaderView(frame: .zero)
    var accountCellViewModels: [AccountSumaryCell.ViewModel] = []
    var accounts: [Account] = []
    
    let refreshControl = UIRefreshControl()
    
    
    lazy var logoutButton: UIBarButtonItem = {
        let image = UIImage(systemName: "rectangle.portrait.and.arrow.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18, weight: .thin))
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(logoutButtonTapped))
        barButton.tintColor = .black
        
        return barButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        fetchData()
    }
}

extension AccountSummaryViewController {
    private func setup() {
        setupTableView()
        setupTableHeaderView()
        setUpRefreshControll()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSumaryCell.self, forCellReuseIdentifier: AccountSumaryCell.reuseID)
        tableView.rowHeight = CGFloat(AccountSumaryCell.rowHeight)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        
        
        
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
    
    
    @objc func logoutButtonTapped() {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    func setUpRefreshControll() {
        refreshControl.tintColor = .systemTeal
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshContent() {
        fetchData()
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accounts.isEmpty else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountSumaryCell.reuseID, for: indexPath) as! AccountSumaryCell
        let account = accountCellViewModels[indexPath.row]
        cell.configure(with: account)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// tesst

// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchData() {
        let group = DispatchGroup()
        //Mock refresh
        let userID = String(Int.random(in: 1..<4))
        group.enter()
        fetchProfile(forUserId: userID) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
                self.configureTableHeaderView(with: profile)
            case .failure(let error):
                switch error {
                    
                case .serverError:
                    self.showErrorAlert(title: "Network Error", mess: "Please check your network connectivity and try again")
                case .decodingError:
                    self.showErrorAlert(title: "Decoding Error", mess: "Please Try Again")
                }
            }
            group.leave()
        }
        group.enter()
        fetchAccounts(forUserId: userID) { result in
            switch result {
            case .success(let accounts):
                self.accounts = accounts
                self.configureTableCells(with: accounts)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSumaryHeaderViewModel(welcomeMessage: "Good morning,",
                                              name: profile.firstName,
                                              date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSumaryCell.ViewModel(accountType: $0.type,
                                        accountName: $0.name,
                                        balance: $0.amount)
        }
    }
    
    func showErrorAlert(title: String, mess: String) {
        let alert = UIAlertController(title: title, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
