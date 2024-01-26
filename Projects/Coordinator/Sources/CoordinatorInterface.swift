//
//  CoordinatorInterface.swift
//  Coordinator
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity

public protocol SignCoordinatorInterface: ParentCoordinator, Coordinator { }

public protocol HomeCoordinatorInterface: ParentCoordinator, Coordinator {
    func travelRegisteration()
    func trip()
}

public protocol CountryCoordinatorInterface: ParentCoordinator, ChildCoordinator {
    func calendar(tripRequest: TripRequest)
}

public protocol CalendarCoordinatorInterface: ParentCoordinator, ChildCoordinator { 
    func companion(tripRequest: TripRequest)
}

public protocol CompanionCoordinatorInterface: ParentCoordinator, ChildCoordinator {
    func changeCompanionName(index: IndexPath, tripUserItemRequest: TripUserItemRequest)
    func travelTitle(tripRequest: TripRequest)
    func changedComanionName(index: IndexPath, tripUserItemRequest: TripUserItemRequest)
}

public protocol ChangeCompanionNameCoordinatorInterface:ParentCoordinator, ChildCoordinator {
    func companion(index: IndexPath, tripUserItemRequest: TripUserItemRequest)
}

public protocol TripCoordinatorInterface: ParentCoordinator, ChildCoordinator { }

public protocol ExpenditureCoordinatorInterface: ParentCoordinator, ChildCoordinator {
    func expenditureEdit()
}

public protocol ExpenditureEditCoordinatorInterface: ParentCoordinator, ChildCoordinator { }
