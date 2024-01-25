//
//  CompanionCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import Coordinator

final public class CompanionCoordinator: NSObject, CompanionCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var companionNavigationController: UIViewController?

    public var parent: CalendarCoordinatorInterface?
    public let tripRequest: TripRequest

    public init(navigationController: UINavigationController, tripRequest: TripRequest) {
        self.navigationController = navigationController
        self.tripRequest = tripRequest
    }

    public func start(animated: Bool) {
        let companionReactor = CompanionReactor(tripRequest: tripRequest)
        let companionViewController = CompanionViewController(coordinator: self, reactor: companionReactor)
        companionNavigationController = companionViewController
        navigationController.pushViewController(companionNavigationController!, animated: animated)
    }

    public func coordinatorDidFinish() {
        companionNavigationController = nil
        parent?.coordinatorDidFinish()
        parent?.childDidFinish(self)
    }

    deinit {
        print("ExpenditureCoordinator is de-initialized.")
    }
}
