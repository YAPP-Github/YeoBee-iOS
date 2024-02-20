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

public protocol ExpenditureCoordinatorDelegate: AnyObject {
    func deletedTrip()
}

final public class ExpenditureCoordinator: NSObject, ExpenditureCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var expenditureNavigationController: UINavigationController?
    public var expenditureViewController: ExpenditureViewController?
    public var sharedExpenditureViewController: SharedExpenditureViewController?

    public var parent: TripCoordinatorInterface?
    public let tripItem: TripItem
    public weak var delegate: ExpenditureCoordinatorDelegate?

    public init(navigationController: UINavigationController, tripItem: TripItem) {
        self.navigationController = navigationController
        self.tripItem = tripItem
    }

    public func start(animated: Bool) {
        if tripItem.tripUserList.count > 1 {
            let sharedExpenditureViewController = SharedExpenditureViewController(coordinator: self, tripItem: tripItem)
            self.sharedExpenditureViewController = sharedExpenditureViewController
            expenditureNavigationController = UINavigationController(rootViewController: sharedExpenditureViewController)
        } else {
            let expenditureViewController = ExpenditureViewController(coordinator: self, tripItem: tripItem)
            self.expenditureViewController = expenditureViewController
            expenditureNavigationController = UINavigationController(rootViewController: expenditureViewController)
        }
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

    public func expenditureAdd(tripItem: TripItem, editDate: Date, expenditureTab: ExpenditureTab) {
        let expenditureAddCoordinator = ExpenditureAddCoordinator(
            navigationController: expenditureNavigationController!,
            tripItem: tripItem,
            editDate: editDate,
            expenditureTab: expenditureTab,
            expenseDetail: nil
        )
        expenditureAddCoordinator.parent = self
        expenditureAddCoordinator.delegate = self
        addChild(expenditureAddCoordinator)
        expenditureAddCoordinator.start(animated: true)
    }

    public func expenditureEdit(expenseDetail: ExpenseDetailItem, expenditureTab: ExpenditureTab) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let editDate = dateFormatter.date(from: expenseDetail.payedAt) ?? Date()
        let expenditureAddCoordinator = ExpenditureAddCoordinator(
            navigationController: expenditureNavigationController!,
            tripItem: tripItem,
            editDate: editDate,
            expenditureTab: expenditureTab,
            expenseDetail: expenseDetail
        )
        expenditureAddCoordinator.parent = self
        expenditureAddCoordinator.delegate = self
        addChild(expenditureAddCoordinator)
        expenditureAddCoordinator.start(animated: true)
    }

    public func totalExpenditureList() {
        let totalExpenditureViewController = TotalExpenditureViewController(coordinator: self)
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
        expenditureNavigationController?.pushViewController(totalExpenditureViewController, animated: true)
    }

    public func totalBudgetExpenditureList() {
//        let totalBudgetExpenditureViewController = TotalBudgetExpenditureViewController(
//            coordinator: self,
//            expenseType: .individual
//        )
//        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
//        expenditureNavigationController?.pushViewController(totalBudgetExpenditureViewController, animated: true)
    }

    public func expenditureDetail(expenseType: ExpenditureTab, expenseItem: ExpenseItem) {
        let expenditureDetailViewController = ExpenditureDetailViewController(
            coordinator: self,
            expenseType: expenseType,
            expenseItem: expenseItem
        )
        expenditureNavigationController?.tabBarController?.tabBar.isHidden = true
        expenditureNavigationController?.pushViewController(expenditureDetailViewController, animated: true)
    }

    public func tripSetting() {
        if let expenditureNavigationController {
            expenditureNavigationController.tabBarController?.tabBar.isHidden = true
            let settingCoordinator = SettingCoordinator(navigationController: expenditureNavigationController, tripItem: tripItem)
            settingCoordinator.delegate = self
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

// MARK: - 여행 삭제 후
extension ExpenditureCoordinator: SettingCoordinatorDelegate {
    public func deletedTrip() {
        delegate?.deletedTrip()
    }
}
