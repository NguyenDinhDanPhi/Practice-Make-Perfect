//
//  NotificationViewController.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//
import UIKit

class NotificationViewController: UIViewController {
    
    private lazy var notifiListView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notification"
        setUpView()
        setUpAction()
    }
    
    func setUpView() {
        view.addSubview(notifiListView)
        
        NSLayoutConstraint.activate([
            notifiListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notifiListView.leftAnchor.constraint(equalTo: view.leftAnchor),
            notifiListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            notifiListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        let data = EmptyStateViewData(numberOfButtons: .oneButton,
                                      titleText: "Không Thể tải danh sách thông báo",
                                      subtitleText: "vui lòng thử lại",
                                      imageDetails: "empy",
                                      textRetryButton: "tải lại", textBackButton: "", textExistButton: "")
    
        let emptyStateVC = EmptyStateViewController.createEmptyStateViewController(data: data)
            emptyStateVC.addToParentViewController(self, in: notifiListView)
    }
    
    func setUpAction() {
//        notifiListView.singupAction = { [weak self] in
//            print("hâhhahahah")
        //}
    }
}

