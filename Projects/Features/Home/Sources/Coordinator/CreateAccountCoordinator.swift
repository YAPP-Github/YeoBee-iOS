//
//  CreateAccountCoordinator.swift
//  Sign
//
//  Created by 태태's MacBook on 1/17/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator

final public class CreateAccountCoordinator: CreateAccountCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start(animated: Bool = false) {
        DispatchQueue.main.async {
            let createAccountViewController = CreateAccountViewController()
            let reactor = CreateAccountReactor()
            createAccountViewController.reactor = reactor
            createAccountViewController.coordinator = self
            self.navigationController.pushViewController(createAccountViewController, animated: true)
        }
    }
    
    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }
    
    public func onboarding() {
        navigationController.dismiss(animated: true)
        let onboardingCoordinator = OnboardingCoordinator(navigationController: self.navigationController)
        onboardingCoordinator.start(animated: true)
    }

    public func showAgreeSheet(nickName: String) {
        let agreeBottomSheetViewController = AgreeBottomSheetViewController(
            coordinator: self,
            nickName: nickName

        )
        navigationController.presentBottomSheet(presentedViewController: agreeBottomSheetViewController, height: 360)
    }

    deinit {
        print("CreateAccountCoordinator is de-initialized.")
    }
}
