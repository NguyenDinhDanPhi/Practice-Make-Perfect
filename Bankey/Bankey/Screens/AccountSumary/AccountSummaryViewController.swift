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
    var profileManager: ProfileManageable = ProfileManager()
    
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
          
          // Testing - random number selection
          let userId = String(Int.random(in: 1..<4))
          
          fetchProfile(group: group, userId: userId)
          fetchAccounts(group: group, userId: userId)
          
          group.notify(queue: .main) {
              self.reloadView()
          }
      }
      
      private func fetchProfile(group: DispatchGroup, userId: String) {
      group.enter()
      profileManager.fetchProfile(forUserID: userId) { result in
          switch result {
          case .success(let profile):
              self.profile = profile
          case .failure(let error):
              self.displayError(error)
          }
          group.leave()
      }
  }
      
  private func fetchAccounts(group: DispatchGroup, userId: String) {
      group.enter()
      fetchAccounts(forUserId: userId) { result in
          switch result {
          case .success(let accounts):
              self.accounts = accounts
          case .failure(let error):
              self.displayError(error)
          }
          group.leave()
      }
  }
      
  private func reloadView() {
      self.tableView.refreshControl?.endRefreshing()
      
      guard let profile = self.profile else { return }
      
      self.configureTableHeaderView(with: profile)
      self.configureTableCells(with: self.accounts)
      self.tableView.reloadData()
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
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, mess: titleAndMessage.1)
    }

    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "We could not process your request. Please try again."
        case .decodingError:
            title = "Network Error"
            message = "Ensure you are connected to the internet. Please try again."
        }
        return (title, message)
    }
}
// MARK: Unit testing
extension AccountSummaryViewController {
    func titleAndMessageForTesting(for error: NetworkError) -> (String, String) {
            return titleAndMessage(for: error)
    }
}
