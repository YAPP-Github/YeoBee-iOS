//
//  BottomSheetPresentationController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/24.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

class BottomPresentationController: UIPresentationController {

    private let dimmedBackgroundView = UIView()
    private let dimmedMaxAlpha: CGFloat = 0.2
    var height: CGFloat = 0
    var isShowDimmedView: Bool = true
    private var hasSetPointOrigin = false
    private var pointOrigin: CGPoint?
    
    override init(
        presentedViewController: UIViewController,
        presenting presentingViewController: UIViewController?
    ) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        presentedView?.addGestureRecognizer(panGestureRecognizer)
        dimmedBackgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func containerViewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = presentedView?.frame.origin
        }
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame = CGRect.zero
        if let containerBounds = containerView?.bounds {
            frame = CGRect(x: 0,
                           y: containerBounds.height - height,
                           width: containerBounds.width,
                           height: height)
        }
        return frame
    }

    override func presentationTransitionWillBegin() {
        if let containerView = self.containerView,
            let coordinator = presentingViewController.transitionCoordinator {
            containerView.addSubview(dimmedBackgroundView)
            dimmedBackgroundView.backgroundColor = isShowDimmedView ? .black : .clear
            dimmedBackgroundView.frame = containerView.bounds
            dimmedBackgroundView.alpha = 0
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.dimmedBackgroundView.alpha = self?.dimmedMaxAlpha ?? .zero
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = self.presentingViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.dimmedBackgroundView.alpha = 0
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        self.dimmedBackgroundView.removeFromSuperview()
    }
    
    @objc private func backgroundTapped() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: presentedView)
        guard translation.y >= 0 else { return }
        presentedView?.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        self.dimmedBackgroundView.alpha = min(1.0, 1.0 - (translation.y / (presentedView?.frame.height ?? 0))) * dimmedMaxAlpha
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: presentedView)
            
            if presentedView?.frame.origin.y ?? 0 - (pointOrigin?.y ?? 0) > ((pointOrigin?.y ?? 0) + 100){
                backgroundTapped()
            }
            
            if dragVelocity.y >= 1000 {
                backgroundTapped()
            }
            else {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.presentedView?.frame.origin = self?.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}

class BottomSheetTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var height: CGFloat = 0
    
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?, source: UIViewController
    ) -> UIPresentationController? {
        let overlay = BottomPresentationController(presentedViewController: presented, presenting: presenting)
        overlay.height = self.height
        return overlay
    }
}

public extension UIViewController {
    func presentBottomSheet(presentedViewController: UIViewController, height: CGFloat) {
        let overlayTransitioningDelegate = BottomSheetTransitioningDelegate()
        overlayTransitioningDelegate.height = height
        presentedViewController.transitioningDelegate = overlayTransitioningDelegate
        presentedViewController.modalPresentationStyle = .custom
        present(presentedViewController, animated: true, completion: nil)
    }
}
