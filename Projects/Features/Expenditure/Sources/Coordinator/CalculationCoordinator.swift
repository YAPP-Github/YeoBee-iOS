//
//  CalculationCoordinator.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 2/21/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import Coordinator

import ExpenditureEdit
import Setting
import Entity

import Dependencies
import YBDependency
import UseCase

final public class CalculationCoordinator: NSObject, CalculationCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var calculationNavigationController: UINavigationController?

    public var parent: TripCoordinatorInterface?
    public let tripItem: TripItem

    public init(navigationController: UINavigationController, tripItem: TripItem) {
        self.navigationController = navigationController
        self.tripItem = tripItem
    }

    public func start(animated: Bool) {
        let tripCalculationViewController = TripCalculationViewController(coordinator: self, tripItem: tripItem)
        calculationNavigationController = UINavigationController(rootViewController: tripCalculationViewController)
    }

    public func popDidFinish() {
        calculationNavigationController?.tabBarController?.tabBar.isHidden = false
        calculationNavigationController?.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        calculationNavigationController = nil
        parent?.coordinatorDidFinish()
        parent?.childDidFinish(self)
    }

    deinit {
        print("CalculationCoordinator is de-initialized.")
    }
}
