//
//  PartialSheetPresentationController.swift
//  DemoNotification
//
//  Created by Dan Phi on 27/5/25.
//
import UIKit
import UIKit

class PartialSheetPresentationController: UIPresentationController {
    private let heightRatio: CGFloat = 0.1

    // MARK: – Dimming view để bắt tap bên ngoài
    private lazy var dimmingView: UIView = {
        let v = UIView(frame: containerView?.bounds ?? .zero)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        v.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDimmingTap))
        v.addGestureRecognizer(tap)
        return v
    }()

    // MARK: – Presentation
    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }
        // Thêm dimming view
        dimmingView.frame = container.bounds
        container.addSubview(dimmingView)

        // Fade in dimming
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)

        // Thêm pan gesture cho swipe-down
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        presentedView?.addGestureRecognizer(pan)
    }

    // MARK: – Dismissal
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }

    // MARK: – Khung của sheet
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let height = container.bounds.height * heightRatio
        return CGRect(
            x: 0,
            y: container.bounds.height - height,
            width: container.bounds.width,
            height: height
        )
    }

    // MARK: – Tap ngoài để dismiss
    @objc private func handleDimmingTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    // MARK: – Swipe-down to dismiss
    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        guard let presented = presentedView else { return }
        let translation = pan.translation(in: presented)

        switch pan.state {
        case .changed:
            if translation.y > 0 {
                presented.frame.origin.y = frameOfPresentedViewInContainerView.origin.y + translation.y
            }
        case .ended, .cancelled:
            let velocity = pan.velocity(in: presented).y
            let shouldDismiss = translation.y > presented.bounds.height / 3 || velocity > 1000
            if shouldDismiss {
                presentedViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.2) {
                    presented.frame = self.frameOfPresentedViewInContainerView
                }
            }
        default:
            break
        }
    }
}

class PartialSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    // Trả về custom presentation controller
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return PartialSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }

    // Nếu muốn custom animation thêm, có thể override:
    // func animationController(forPresented:…, presenting:…, source:…) -> UIViewControllerAnimatedTransitioning? { … }
    // func animationController(forDismissed:) -> UIViewControllerAnimatedTransitioning? { … }
}
