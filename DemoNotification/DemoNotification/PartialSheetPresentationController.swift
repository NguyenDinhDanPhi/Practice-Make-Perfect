//
//  PartialSheetPresentationController.swift
//  DemoNotification
//
//  Created by Dan Phi on 27/5/25.
//
import UIKit

/// Custom presentation controller allowing configurable height ratio
class PartialSheetPresentationController: UIPresentationController {
    /// Ratio of container height the sheet should occupy (0.0...1.0)
    private let heightRatio: CGFloat

    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         heightRatio: CGFloat) {
        self.heightRatio = heightRatio
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
    }

    // MARK: – Dimming view for background tap
    private lazy var dimmingView: UIView = {
        let v = UIView(frame: containerView?.bounds ?? .zero)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        v.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDimmingTap))
        v.addGestureRecognizer(tap)
        return v
    }()

    // MARK: – Presentation lifecycle
    override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }
        // Insert dimming view
        dimmingView.frame = container.bounds
        container.addSubview(dimmingView)

        // Fade-in animation
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1
        }, completion: nil)

        // Add pan gesture for swipe-down
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        presentedView?.addGestureRecognizer(pan)
    }

    override func dismissalTransitionWillBegin() {
        // Fade-out animation
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }

    // MARK: – Frame of sheet
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

    // MARK: – Handle dimming tap
    @objc private func handleDimmingTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }

    // MARK: – Handle swipe-down
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

/// Transitioning delegate that creates PartialSheetPresentationController with given ratio
class PartialSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let heightRatio: CGFloat

    init(heightRatio: CGFloat) {
        self.heightRatio = heightRatio
    }

    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        return PartialSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            heightRatio: heightRatio
        )
    }
}
