//
//  CalendarCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator

final public class CalendarCoordinator: NSObject, CalendarCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var calendarNavigationController: UIViewController?

    public var parent: CountryCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let calendarViewController = CalendarViewController(coordinator: self)
        calendarNavigationController = calendarViewController
        navigationController.pushViewController(calendarViewController, animated: animated)
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
    public func companion() {
        
    }
}
