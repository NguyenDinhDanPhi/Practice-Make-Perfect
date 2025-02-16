//
//  UIResponder+.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 16/02/2025.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
