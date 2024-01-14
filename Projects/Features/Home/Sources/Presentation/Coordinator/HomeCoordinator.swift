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
import Trip

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
        navigationController.isNavigationBarHidden = true
        navigationController.pushViewController(homeViewController, animated: animated)
    }
}

extension HomeCoordinator {

    public func travelRegisteration() {
        let travelRegistrationCoordinator = TravelRegistrationCoordinator(navigationController: navigationController)
        travelRegistrationCoordinator.parent = self
        addChild(travelRegistrationCoordinator)
        travelRegistrationCoordinator.start(animated: true)
    }

    public func trip() {
        let tripCoordinator = TripCoordinator(navigationController: navigationController)
        tripCoordinator.parent = self
        addChild(tripCoordinator)
        tripCoordinator.start(animated: true)
    }
}