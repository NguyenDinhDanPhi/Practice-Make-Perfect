import UIKit

class MainViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tạo các view controllers cho từng tab
        let homeViewController = HomeViewController()
        let notificationViewController = NotificationViewController()
        
        // Tạo Tab Bar Items
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        notificationViewController.tabBarItem = UITabBarItem(title: "Notification", image: UIImage(systemName: "bell.fill"), tag: 1)
        
        // Tạo UITabBarController
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeViewController, notificationViewController]
        tabBarController.tabBar.barTintColor = .white
                tabBarController.tabBar.isTranslucent = false
        // Thiết lập TabBarController cho MainViewController
        self.view.addSubview(tabBarController.view)
        addChild(tabBarController)
        tabBarController.didMove(toParent: self)
    }
}
