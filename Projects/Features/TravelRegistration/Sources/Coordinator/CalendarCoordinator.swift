//
//  CalendarCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import Coordinator

final public class CalendarCoordinator: NSObject, CalendarCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var calendarNavigationController: UIViewController?

    public var parent: CountryCoordinatorInterface?
    public let tripRequest: TripRequest

    public init(navigationController: UINavigationController, tripRequest: TripRequest) {
        self.navigationController = navigationController
        self.tripRequest = tripRequest
    }

    public func start(animated: Bool) {
        let calendarReactor = CalendarReactor(tripRequest: tripRequest)
        let calendarViewController = CalendarViewController(coordinator: self, 
                                                            reactor: calendarReactor)
        calendarNavigationController = calendarViewController
        navigationController.pushViewController(calendarNavigationController!, animated: animated)
    }

    public func coordinatorDidFinish() {
        calendarNavigationController = nil
        parent?.coordinatorDidFinish()
        parent?.childDidFinish(self)
    }

    deinit {
        print("ExpenditureCoordinator is de-initialized.")
    }
}

extension CalendarCoordinator {
    public func companion(tripRequest: TripRequest) {
        let companionCoordinator = CompanionCoordinator(navigationController: navigationController,
                                                        tripRequest: tripRequest)
        companionCoordinator.parent = self
        addChild(companionCoordinator)
        companionCoordinator.start(animated: true)
    }
}
