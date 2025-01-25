//
//  UIViewController+.swift
//  Bankey
//
//  Created by dan phi on 25/01/2025.
//

import UIKit

extension UIViewController {
    
    func setStatusBar() {
        var statusBarSize: CGSize {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first?.statusBarManager?.statusBarFrame.size ?? .zero
        }
        let frame = CGRect(origin: .zero, size: statusBarSize)
        let statusBarView = UIView(frame: frame)
        view.addSubview(statusBarView)
    }
    
    func setTabBarImage(imageName: String, title: String) {
        let config = UIImage.SymbolConfiguration(scale: .large)
        let img = UIImage(systemName: imageName, withConfiguration: config)
        tabBarItem = UITabBarItem(title: title, image: img, tag: 0)
    }
}
