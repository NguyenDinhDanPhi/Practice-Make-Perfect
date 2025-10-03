//
//  KeyboardAdjustable.swift
//  TestNumberPhone
//
//  Created by Dan Phi on 3/10/25.
//


import UIKit

protocol KeyboardAdjustable: AnyObject {
    var bottomConstraint: NSLayoutConstraint? { get set }
    var bottomSpacingWhenHidden: CGFloat { get }
    var keyboardPadding: CGFloat { get set }
}

extension KeyboardAdjustable where Self: UIViewController {
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification, object: nil, queue: .main) { [weak self] noti in
            self?.handleKeyboard(notification: noti)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] noti in
            self?.handleKeyboard(notification: noti)
        }
    }
    
    private func handleKeyboard(notification: Notification) {
        guard let selfVC = self as? UIViewController else { return }
        guard
            let userInfo = notification.userInfo,
            let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let curveRaw = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
        else { return }
        
        var overlap: CGFloat = 0
        if let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let kbEnd = selfVC.view.convert(endFrame, from: nil)
            overlap = max(0, selfVC.view.bounds.maxY - kbEnd.origin.y)
        }
        
        if overlap > 0 {
            bottomConstraint?.constant = -(overlap + keyboardPadding)
        } else {
            bottomConstraint?.constant = bottomSpacingWhenHidden
        }
        
        let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
        UIView.animate(withDuration: duration, delay: 0, options: options) {
            selfVC.view.layoutIfNeeded()
        }
    }
}
