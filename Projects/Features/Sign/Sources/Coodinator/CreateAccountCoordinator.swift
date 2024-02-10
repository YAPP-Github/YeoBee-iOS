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
    public var createAccountNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: SignCoordinatorInterface?

    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let createAccountViewController = CreateAccountViewController()
        createAccountNavigationController = UINavigationController(rootViewController: createAccountViewController)
        let reactor = CreateAccountReactor()
        createAccountViewController.reactor = reactor
        createAccountViewController.coordinator = self
        navigationController.pushViewController(createAccountViewController, animated: true)
    }

    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        createAccountNavigationController?.dismiss(animated: true)
        parent?.childDidFinish(self)
    }

    deinit {
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}
