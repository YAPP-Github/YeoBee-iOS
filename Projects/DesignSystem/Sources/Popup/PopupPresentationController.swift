//
//  PopupPresentationController.swift
//  DesignSystem
//
//  Created by Hoyoung Lee on 2/9/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

final internal class PopupPresentationController: UIPresentationController {

    fileprivate let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .ybColor(.black).withAlphaComponent(0.2)
        return view
    }()

    override func presentationTransitionWillBegin() {

        guard let containerView = containerView else { return }

        dimmedBackgroundView.frame = containerView.bounds
        containerView.insertSubview(dimmedBackgroundView, at: 0)

        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmedBackgroundView.alpha = 1.0
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.dimmedBackgroundView.alpha = 0.0
        }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {

        guard let presentedView = presentedView else { return }

        presentedView.frame = frameOfPresentedViewInContainerView
    }

}

class PopupTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?, source: UIViewController
    ) -> UIPresentationController? {
        return PopupPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

extension UIViewController {
    public func presentPopup(presentedViewController: UIViewController) {
        let overlayTransitioningDelegate = PopupTransitioningDelegate()
        presentedViewController.transitioningDelegate = overlayTransitioningDelegate
        presentedViewController.modalPresentationStyle = .custom
        present(presentedViewController, animated: true, completion: nil)
    }
}
