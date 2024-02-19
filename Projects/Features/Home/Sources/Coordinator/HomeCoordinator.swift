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
import MyPage

public protocol HomeCoordinatorDelegate: AnyObject {
    func finishedRegistration()
}

final public class HomeCoordinator: HomeCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public weak var delegate: HomeCoordinatorDelegate?

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
        countryCoordinator.delegate = self
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
    
    public func myPage() {
        let myPageCoordinator = MyPageCoordinator(navigationController: navigationController)
        myPageCoordinator.start(animated: true)
    }
}

extension HomeCoordinator: TravelRegistrationCoordinatorDelegate {
    public func finishedRegistration() {
        delegate?.finishedRegistration()
    }
}
