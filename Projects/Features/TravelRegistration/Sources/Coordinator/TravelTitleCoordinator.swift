//
//  TravelTitleCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/26/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import Coordinator

final public class TravelTitleCoordinator: NSObject, TravelTitleCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var travelTitleNavigationController: UIViewController?

    public var parent: CompanionCoordinatorInterface?
    public let tripRequest: TripRequest

    public init(navigationController: UINavigationController, tripRequest: TripRequest) {
        self.navigationController = navigationController
        self.tripRequest = tripRequest
    }
    
    public func start(animated: Bool) { 
        let travelTitleReactor = TravelTitleReactor(tripRequest: tripRequest)
        let travelTitleViewController = TravelTitleViewController(coordinator: self,
                                                                  reactor: travelTitleReactor)
        travelTitleNavigationController = travelTitleViewController
        navigationController.pushViewController(travelTitleNavigationController!, animated: true)
    }

    public func coordinatorDidFinish() {
        travelTitleNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("TravelTitleCoordinator is de-initialized.")
    }
}

