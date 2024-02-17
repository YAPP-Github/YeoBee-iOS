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
import Setting
import Entity

import Dependencies
import YBDependency
import UseCase

final public class ExpenditureCoordinator: NSObject, ExpenditureCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var expenditureNavigationController: UINavigationController?
    public var expenditureViewController: ExpenditureViewController?

    public var parent: TripCoordinatorInterface?
    public let tripItem: TripItem

    public init(navigationController: UINavigationController, tripItem: TripItem) {
        self.navigationController = navigationController
        self.tripItem = tripItem
    }

    public func start(animated: Bool) {
        let expenditureViewController = ExpenditureViewController(coordinator: self, tripItem: tripItem)
        self.expenditureViewController = expenditureViewController
        expenditureNavigationController = UINavigationController(rootViewController: expenditureViewController)
    }

    public func popDidFinish() {
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = false
        expenditureNavigationController?.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        expenditureViewController = nil
        expenditureNavigationController = nil
        parent?.coordinatorDidFinish()
        parent?.childDidFinish(self)
    }

    deinit {
        print("ExpenditureCoordinator is de-initialized.")
    }
}

extension ExpenditureCoordinator {

    public func expenditureAdd(tripId: Int, editDate: Date) {
        let expenditureAddCoordinator = ExpenditureAddCoordinator(
            navigationController: expenditureNavigationController!,
            tripId: tripId,
            editDate: editDate
        )
        expenditureAddCoordinator.parent = self
        expenditureAddCoordinator.delegate = self
        addChild(expenditureAddCoordinator)
        expenditureAddCoordinator.start(animated: true)
    }

    public func expenditureEdit(tripId: Int, expenseDetail: ExpenseDetailItem) {
        let expenditureEditCoordinator = ExpenditureEditCoordinator(
            navigationController: expenditureNavigationController!,
            tripId: tripId,
            expenseDetail: expenseDetail
        )
        expenditureEditCoordinator.parent = self
        addChild(expenditureEditCoordinator)
        expenditureEditCoordinator.start(animated: true)
    }

    public func totalExpenditureList() {
        let totalExpenditureViewController = TotalExpenditureViewController(coordinator: self)
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
        expenditureNavigationController?.pushViewController(totalExpenditureViewController, animated: true)
    }

    public func totalBudgetExpenditureList() {
        let totalBudgetExpenditureViewController = TotalBudgetExpenditureViewController(
            coordinator: self,
            expenseType: .individual
        )
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
        expenditureNavigationController?.pushViewController(totalBudgetExpenditureViewController, animated: true)
    }

    public func expenditureDetail(expenseItem: ExpenseItem) {
        let expenditureDetailViewController = ExpenditureDetailViewController(
            coordinator: self,
            expenseItem: expenseItem
        )
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
        expenditureNavigationController?.pushViewController(expenditureDetailViewController, animated: true)
    }

    public func tripSetting() {
        if let expenditureNavigationController {
            expenditureNavigationController.tabBarController?.tabBar.isHidden = true
            let settingCoordinator = SettingCoordinator(navigationController: expenditureNavigationController, tripItem: tripItem)
            settingCoordinator.parent = self
            addChild(settingCoordinator)
            settingCoordinator.start(animated: true)
        }
    }

    public func showFilterBottomSheet(selectedExpenseFilter: PaymentMethod?) {
        let filterBottomSheetViewController = FilterBottomSheetViewController(
            coordinator: self,
            selectedExpenseFilter: selectedExpenseFilter
        )
        expenditureNavigationController?.presentBottomSheet(
            presentedViewController: filterBottomSheetViewController,
            height: 280
        )
    }

    public func selectExpenseFilter(selectedExpenseFilter: PaymentMethod?) {
        expenditureViewController?.selectExpenseFilter(selectedExpenseFilter: selectedExpenseFilter)
        expenditureNavigationController?.dismiss(animated: true)
    }
}

extension ExpenditureCoordinator: ExpenditureAddCoordinatorDelegate {
    public func dismissRegisterExpense(editDate: Date) {
        expenditureViewController?.getExpenseList(editDate: editDate)
    }
}
