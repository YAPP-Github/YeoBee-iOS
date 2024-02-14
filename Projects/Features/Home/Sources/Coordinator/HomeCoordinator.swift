//
//  HomeCoordinator.swift
//  Home
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator
import Entity
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
        navigationController.pushViewController(homeViewController, animated: animated)
    }
}

extension HomeCoordinator {

    public func travelRegisteration() {
        let countryCoordinator = TravelRegistrationCoordinator(navigationController: navigationController)
        countryCoordinator.parent = self
        addChild(countryCoordinator)
        countryCoordinator.start(animated: true)
    }

    public func trip(tripItem: TripItem) {
        let tripCoordinator = TripCoordinator(navigationController: navigationController, tripItem: tripItem)
        tripCoordinator.parent = self
        addChild(tripCoordinator)
        tripCoordinator.start(animated: true)
    }
}
