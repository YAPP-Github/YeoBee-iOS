//
//  CoordinatorInterface.swift
//  Coordinator
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

public protocol SignCoordinatorInterface: ParentCoordinator, Coordinator { }

public protocol HomeCoordinatorInterface: ParentCoordinator, Coordinator {
    func travelRegister()
    func travelRegister(navigationController: UINavigationController, animated: Bool)
}

public protocol TravelRegistrationCoordinatorInterface: ParentCoordinator, ChildCoordinator {
}
