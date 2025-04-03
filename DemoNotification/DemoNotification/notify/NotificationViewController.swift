//
//  NotificationViewController.swift
//  DemoNotification
//
//  Created by dan phi on 3/4/25.
//
import UIKit

class NotificationViewController: UIViewController {
    
    private lazy var notifiListView: EmptyNotificationView = {
        let view = EmptyNotificationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notification"
        setUpView()
    }
    
    func setUpView() {
        view.addSubview(notifiListView)
        
        // Cài đặt Auto Layout cho notifiListView
        NSLayoutConstraint.activate([
            notifiListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            notifiListView.leftAnchor.constraint(equalTo: view.leftAnchor),
            notifiListView.rightAnchor.constraint(equalTo: view.rightAnchor),
            notifiListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

