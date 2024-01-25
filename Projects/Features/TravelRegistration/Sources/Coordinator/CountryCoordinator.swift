//
//  CountryCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator

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
        let countryViewController = CountryViewController(coordinator: self)
        navigationController.pushViewController(countryViewController, animated: animated)
    }

    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        travelRegistrationNavigationController?.dismiss(animated: true)
        parent?.childDidFinish(self)
    }

    deinit {
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}

extension CountryCoordinator {
    public func calendar() {
        let calendarCoordinator = CalendarCoordinator(navigationController: navigationController)
        calendarCoordinator.parent = self
        addChild(calendarCoordinator)
        calendarCoordinator.start(animated: true)
    }
}
