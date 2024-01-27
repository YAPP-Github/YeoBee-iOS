//
//  TravelRegistrationCoordinator.swift
//  TravelRegistration
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator

final public class TravelRegistrationCoordinator: Coordinator, ParentCoordinator {
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start(animated: Bool) {
        let countryCoordinator = CountryCoordinator(navigationController: navigationController)
        addChild(countryCoordinator)
        countryCoordinator.start(animated: false)
    }
}
