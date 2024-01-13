//
//  HomeCoordinator.swift
//  Home
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator
import TravelRegistration

final public class HomeCoordinator: HomeCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = false) {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.pushViewController(homeViewController, animated: animated)
    }
}

extension HomeCoordinator {

    public func travelRegister() {
        self.travelRegister(navigationController: navigationController, animated: true)
    }

    public func travelRegister(navigationController: UINavigationController, animated: Bool) {
        let productsCoordinator = TravelRegistrationCoordinator(navigationController: navigationController)
        productsCoordinator.parent = self
        addChild(productsCoordinator)
        productsCoordinator.start(animated: animated)
    }
}
