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
    func trip(tripItem: TripItem)
}

public protocol TravelRegistrationCoordinatorInterface: ParentCoordinator, ChildCoordinator { }

public protocol TripCoordinatorInterface: ParentCoordinator, ChildCoordinator { }

public protocol ExpenditureCoordinatorInterface: ParentCoordinator, ChildCoordinator {
    func expenditureAdd(tripItem: TripItem, editDate: Date, expenditureTab: ExpenditureTab, hasSharedBudget: Bool)
}

public protocol SettingCoordinatorInterface: ParentCoordinator, ChildCoordinator { }

public protocol ExpenditureAddCoordinatorInterface: ParentCoordinator, ChildCoordinator {
    func showCurrencyBottomSheet(currenyList: [Currency], selectedCurrency: Currency, expenseType: ExpenseType)
}

public protocol ExpenditureEditCoordinatorInterface: ParentCoordinator, ChildCoordinator { }

public protocol CreateAccountCoordinatorInterface: Coordinator { }

public protocol OnboardingCoordinatorInterface: Coordinator { }

public protocol MyPageCoordinatorInterface: Coordinator { }

public protocol CalculationCoordinatorInterface: Coordinator { }

public protocol RevokeCoordinatorInterface: Coordinator { }
