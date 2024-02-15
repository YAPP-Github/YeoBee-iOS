//
//  ToastPresentationController.swift
//  DesignSystem
//
//  Created by Hoyoung Lee on 1/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

import UIKit

public class Toast {
    private static var isShowingToast: Bool = false

    public let view: ToastView
    private var closeTimer: Timer?

    private var startY: CGFloat = 44
    private var startShiftY: CGFloat = 0

    public static func text(
        icon: ToastIcon,
        _ text: String
    ) -> Toast {
        let view = ToastView(child: YBToastView(icon: icon, text))
        return self.init(view: view)
    }

    public required init(view: ToastView) {
        self.view = view

        enablePanToClose()
    }

    public func show(after delay: TimeInterval = 0) {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)

        if !Toast.isShowingToast {
            ToastHelper.topController()?.view.addSubview(view)
            view.createView(for: self)
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                self.view.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 36)
            } completion: { [self] _ in
                Toast.isShowingToast = true
                configureCloseTimer()
            }
        }

    }

    public func close(animated: Bool = true) {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [.curveEaseIn, .allowUserInteraction],
                       animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: -36)
        }, completion: { _ in
            self.view.removeFromSuperview()
            Toast.isShowingToast = false
        })
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension Toast {
    private func enablePanToClose() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(toastOnPan(_:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(toastOnTap(_:)))
        self.view.addGestureRecognizer(pan)
        self.view.addGestureRecognizer(tap)
    }

    @objc private func toastOnPan(_ gesture: UIPanGestureRecognizer) {
        closeTimer?.invalidate()
        guard let topVc = ToastHelper.topController() else {
            return
        }

        switch gesture.state {
        case .began:
            startY = self.view.frame.origin.y
            startShiftY = gesture.location(in: topVc.view).y
            close()
        case .changed:
            let delta = gesture.location(in: topVc.view).y - startShiftY - 75

            let shouldApply = delta <= 0

            if shouldApply {
                self.view.frame.origin.y = startY + delta - 36
            }

        case .ended:
            let threshold = 15.0
            let ammountOfUserDragged = abs(startY - self.view.frame.origin.y)
            let shouldDismissToast = ammountOfUserDragged > threshold

            if shouldDismissToast {
                close()
            } else {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) {
                    self.view.frame.origin.y = self.startY
                } completion: { [self] _ in
                    close()
                }
            }

        case .cancelled, .failed:
            close()
        default:
            break
        }
    }

    @objc func toastOnTap(_ gesture: UITapGestureRecognizer) {
        closeTimer?.invalidate()
        close()
    }

    private func configureCloseTimer() {
        closeTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [self] _ in
            close()
        }
    }
}

class ToastHelper {

    public static func topController() -> UIViewController? {
        if var topController = keyWindow()?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    private static func keyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            for scene in UIApplication.shared.connectedScenes {
                guard let windowScene = scene as? UIWindowScene else {
                    continue
                }
                if windowScene.windows.isEmpty {
                    continue
                }
                guard let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                    continue
                }
                return window
            }
            return nil
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }

}
