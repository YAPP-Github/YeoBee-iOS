//
//  CountryCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator
import Entity

final public class CountryCoordinator: CountryCoordinatorInterface {
    public var navigationController: UINavigationController
    public var travelRegistrationNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: HomeCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let countryReactor = CountryReactor()
        let countryViewController = UINavigationController(rootViewController: CountryViewController(coordinator: self, 
                                                                                                     reactor: countryReactor))
        countryViewController.modalPresentationStyle = .overFullScreen
        travelRegistrationNavigationController = countryViewController
        navigationController.present(travelRegistrationNavigationController!, animated: animated)
    }

    public func coordinatorDidFinish() {
        travelRegistrationNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("CountryCoordinator is de-initialized.")
    }
}

extension CountryCoordinator {
    public func calendar(tripRequest: TripRequest) {
        let calendarCoordinator = CalendarCoordinator(navigationController: travelRegistrationNavigationController!,
                                                      tripRequest: tripRequest)
        calendarCoordinator.parent = self
        addChild(calendarCoordinator)
        calendarCoordinator.start(animated: true)
    }
}
