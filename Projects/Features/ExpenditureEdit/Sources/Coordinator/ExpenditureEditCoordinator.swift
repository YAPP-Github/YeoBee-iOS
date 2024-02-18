//
//  ExpenditureEditCoordinator.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator
import Dependencies
import YBDependency
import Entity

public protocol ExpenditureEditCoordinatorDelegate: NSObject {
    func dismissRegisterExpense(editDate: Date)
}

final public class ExpenditureEditCoordinator: ExpenditureEditCoordinatorInterface {
    public var navigationController: UINavigationController
    public var expenditureEditNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: ExpenditureCoordinatorInterface?
    public weak var delegate: ExpenditureEditCoordinatorDelegate?
    public let tripItem: TripItem
    public let expenseDetail: ExpenseDetailItem

    public init(navigationController: UINavigationController, tripItem: TripItem, expenseDetail: ExpenseDetailItem) {
        self.navigationController = navigationController
        self.tripItem = tripItem
        self.expenseDetail = expenseDetail
    }

    public func start(animated: Bool) {
        let expenditureUpdateViewController = ExpenditureUpdateViewController(
            coordinator: self,
            tripItem: tripItem,
            expenseDetail: expenseDetail
        )
        expenditureEditNavigationController = UINavigationController(rootViewController: expenditureUpdateViewController)
        expenditureEditNavigationController?.modalPresentationStyle = .overFullScreen
        navigationController.present(expenditureEditNavigationController!, animated: animated)
    }

    public func dismissRegisterExpense() {
        coordinatorDidFinish()
    }

    public func popDidFinish() {
        expenditureEditNavigationController?.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        expenditureEditNavigationController?.dismiss(animated: true)
        expenditureEditNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}
