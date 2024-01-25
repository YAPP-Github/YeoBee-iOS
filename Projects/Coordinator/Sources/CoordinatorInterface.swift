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
    func travelRegisteration()
    func trip()
}

public protocol CountryCoordinatorInterface: ParentCoordinator, ChildCoordinator {
    func calendar()
}

public protocol CalendarCoordinatorInterface: ParentCoordinator, ChildCoordinator { }

public protocol TripCoordinatorInterface: ParentCoordinator, ChildCoordinator { }

public protocol ExpenditureCoordinatorInterface: ParentCoordinator, ChildCoordinator {
    func expenditureEdit()
}

public protocol ExpenditureEditCoordinatorInterface: ParentCoordinator, ChildCoordinator { }
