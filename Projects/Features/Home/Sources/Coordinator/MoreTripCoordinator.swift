//
//  MoreTripCoordinator.swift
//  Home
//
//  Created by 박현준 on 1/30/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator
import Entity

final public class MoreTripCoordinator: MoreTripCoordinatorInterface {
    public var navigationController: UINavigationController
    public var moreTripNavigationController: UIViewController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: HomeCoordinatorInterface?
    private let tripType: TripType

    public init(navigationController: UINavigationController, tripType: TripType) {
        self.navigationController = navigationController
        self.tripType = tripType
    }

    public func start(animated: Bool) {
        let moreTripReactor = MoreTripReactor(tripType: tripType)
        let moreTripViewController = MoreTripViewController(coordinator: self, reactor: moreTripReactor)
        moreTripNavigationController = moreTripViewController
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(moreTripNavigationController!, animated: animated)
    }
    
    public func coordinatorDidFinish() {
        moreTripNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("MoreTripCoordinator is de-initialized.")
    }
}
