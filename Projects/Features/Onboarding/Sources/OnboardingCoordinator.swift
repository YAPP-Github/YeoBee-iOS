//
//  OnboardingCoordinator.swift
//  Onboarding
//
//  Created by 김태형 on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator

final public class OnboardingCoordinator: OnboardingCoordinatorInterface {
    public var navigationController: UINavigationController
    public var onboardingNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()

    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let onboardingViewController = OnboardingViewController()
        onboardingNavigationController = UINavigationController(rootViewController: onboardingViewController)
        let reactor = OnboardingReactor()
        onboardingViewController.reactor = reactor
        onboardingViewController.coordinator = self
        navigationController.pushViewController(onboardingViewController, animated: true)
    }

    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        onboardingNavigationController?.dismiss(animated: true)
    }

    deinit {
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}
