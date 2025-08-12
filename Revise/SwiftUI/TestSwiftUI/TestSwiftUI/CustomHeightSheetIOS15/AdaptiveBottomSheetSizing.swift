//
//  AdaptiveBottomSheetSizing.swift
//  TestSwiftUI
//
//  Created by Dan Phi on 12/8/25.
//

import UIKit

// AdaptiveBottomSheetSizing.swift
// UIKit layer

import UIKit

public protocol AdaptiveBottomSheetSizing {
    var portraitRatio: CGFloat { get }   // 0.0 ... 1.0  (ví dụ 0.45)
    var landscapeRatio: CGFloat { get }  // 0.0 ... 1.0
}

/// Custom presentation controller allowing configurable height ratio
public final class PartialSheetPresentationController: UIPresentationController {
    private let defaultRatio: CGFloat

    public init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?,
        defaultRatio: CGFloat
    ) {
        self.defaultRatio = defaultRatio
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
    }

    // MARK: Dimming (background)
    private lazy var dimmingView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.black.withAlphaComponent(0.35) // nhẹ như system
        v.alpha = 0
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDimmingTap)))
        return v
    }()

    // MARK: Lifecycle
    public override func presentationTransitionWillBegin() {
        guard let container = containerView else { return }
        dimmingView.frame = container.bounds
        container.addSubview(dimmingView)

        // Bắt đầu dưới đáy → trượt lên vị trí sheet
        presentedView?.frame.origin.y = container.bounds.maxY

        if let tc = presentedViewController.transitionCoordinator {
            tc.animate(alongsideTransition: { [weak self] _ in
                guard let self else { return }
                self.dimmingView.alpha = 1
                self.presentedView?.frame = self.frameOfPresentedViewInContainerView
            })
        } else {
            dimmingView.alpha = 1
            presentedView?.frame = frameOfPresentedViewInContainerView
        }

        // Pan để kéo xuống dismiss
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        presentedView?.addGestureRecognizer(pan)

        // Grabber (thanh nhỏ ở đỉnh)
        addGrabberIfNeeded()
    }

    public override func dismissalTransitionWillBegin() {
        if let tc = presentedViewController.transitionCoordinator {
            tc.animate(alongsideTransition: { [weak self] _ in
                self?.dimmingView.alpha = 0
            }, completion: { [weak self] _ in
                self?.dimmingView.removeFromSuperview()
            })
        } else {
            dimmingView.alpha = 0
            dimmingView.removeFromSuperview()
        }
    }

    // MARK: Layout
    public override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let bounds = container.bounds
        let isLandscape = bounds.width > bounds.height

        let baseRatio: CGFloat = (presentedViewController as? AdaptiveBottomSheetSizing).map {
            isLandscape ? $0.landscapeRatio : $0.portraitRatio
        } ?? defaultRatio

        let height = max(0, min(bounds.height, bounds.height * baseRatio))
        let width  = bounds.width
        let originX: CGFloat = 0
        let originY = bounds.height - height

        return CGRect(x: originX, y: originY, width: width, height: height)
    }

    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        dimmingView.frame = containerView?.bounds ?? .zero
        let frame = frameOfPresentedViewInContainerView
        presentedView?.frame = frame

        // Bo 2 góc trên như system
        presentedView?.layer.cornerRadius = 16
        presentedView?.layer.cornerCurve  = .continuous
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView?.clipsToBounds = true

        // Không dùng shadow "card"
        presentedView?.layer.shadowOpacity = 0
        presentedView?.layer.shadowRadius  = 0
        presentedView?.layer.shadowOffset  = .zero
    }

    // MARK: Actions
    @objc private func handleDimmingTap() {
        presentedViewController.dismiss(animated: true)
    }

    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        guard let presented = presentedView, let container = containerView else { return }
        let translation = pan.translation(in: container)

        switch pan.state {
        case .changed:
            if translation.y > 0 {
                // rubber-band: càng kéo càng "nặng"
                let damped = translation.y * 0.7
                presented.frame.origin.y = frameOfPresentedViewInContainerView.origin.y + damped
            }
        case .ended, .cancelled:
            let velocity = pan.velocity(in: container).y
            let delta = presented.frame.minY - frameOfPresentedViewInContainerView.minY
            let shouldDismiss = delta > presented.bounds.height / 3 || velocity > 1000
            if shouldDismiss {
                presentedViewController.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 0) {
                    presented.frame = self.frameOfPresentedViewInContainerView
                }
            }
        default:
            break
        }
    }

    private func addGrabberIfNeeded() {
        guard let presented = presentedView, presented.viewWithTag(999_777) == nil else { return }
        let grabber = UIView(frame: CGRect(x: 0, y: 8, width: 36, height: 5))
        grabber.tag = 999_777
        grabber.backgroundColor = UIColor.secondaryLabel.withAlphaComponent(0.3)
        grabber.layer.cornerRadius = 2.5
        grabber.center.x = presented.bounds.midX
        grabber.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        presented.addSubview(grabber)
    }
}

// MARK: – Transitioning Delegate
public final class PartialSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private let defaultRatio: CGFloat

    public init(defaultRatio: CGFloat) {
        self.defaultRatio = defaultRatio
        super.init()
    }

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        PartialSheetPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            defaultRatio: defaultRatio
        )
    }
}
