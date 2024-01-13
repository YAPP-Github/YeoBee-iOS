//
//  TravelRegistrationCoordinator.swift
//  TravelRegistration
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator

final public class TravelRegistrationCoordinator: TravelRegistrationCoordinatorInterface {
    public var navigationController: UINavigationController
    public var travelRegistrationNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: HomeCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let travelRegistrationController = CountryViewController()
        travelRegistrationNavigationController = UINavigationController(rootViewController: travelRegistrationController)
        travelRegistrationController.coordinator = self
        travelRegistrationNavigationController?.modalPresentationStyle = .overFullScreen
        navigationController.present(travelRegistrationNavigationController!, animated: animated)
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
