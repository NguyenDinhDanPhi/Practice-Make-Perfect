import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tạo các view controllers cho từng tab
        let homeVC = ViolationWarningViewController()
        let notifVC = NotificationViewController()

        // Bọc từng VC trong UINavigationController
        let homeNav = UINavigationController(rootViewController: homeVC)
        let notifNav = UINavigationController(rootViewController: notifVC)

        // Set tabBarItem
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        notifNav.tabBarItem = UITabBarItem(title: "Notification", image: UIImage(systemName: "bell.fill"), tag: 1)

        // Tạo tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNav, notifNav]
        tabBarController.tabBar.barTintColor = .white
        tabBarController.tabBar.isTranslucent = false

        // Thay đổi: set tabBarController là root
        view.addSubview(tabBarController.view)
        addChild(tabBarController)
        tabBarController.didMove(toParent: self)
    }
}
