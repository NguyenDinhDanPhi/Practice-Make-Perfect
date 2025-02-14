//
//  UIView+.swift
//  Tip-learning Reactive and more
//
//  Created by dan phi on 14/02/2025.
//

import UIKit

extension UIView {
    func addShaDow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let background = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = background
    }
}
