//
//  ExpenditureCoordinator.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 1/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import Coordinator

import ExpenditureEdit
import Entity

final public class ExpenditureCoordinator: NSObject, ExpenditureCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var expenditureNavigationController: UINavigationController?

    public var parent: TripCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let expenditureViewController = ExpenditureViewController(coordinator: self)
        expenditureNavigationController = UINavigationController(rootViewController: expenditureViewController)
    }

    public func popDidFinish() {
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = false
        expenditureNavigationController?.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        expenditureNavigationController = nil
        parent?.coordinatorDidFinish()
        parent?.childDidFinish(self)
    }

    deinit {
        print("ExpenditureCoordinator is de-initialized.")
    }
}

extension ExpenditureCoordinator {

    public func expenditureEdit() {
        let expenditureEditCoordinator = ExpenditureEditCoordinator(navigationController: expenditureNavigationController!)
        expenditureEditCoordinator.parent = self
        addChild(expenditureEditCoordinator)
        expenditureEditCoordinator.start(animated: true)
    }

    public func totalExpenditureList() {
        let totalExpenditureViewController = TotalExpenditureViewController(coordinator: self)
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
        expenditureNavigationController?.pushViewController(totalExpenditureViewController, animated: true)
    }

    public func expenditureDetail(expenseItem: ExpenseItem) {
        let expenditureDetailViewController = ExpenditureDetailViewController(
            coordinator: self,
            expenseItem: expenseItem
        )
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
        expenditureNavigationController?.pushViewController(expenditureDetailViewController, animated: true)
    }
}
