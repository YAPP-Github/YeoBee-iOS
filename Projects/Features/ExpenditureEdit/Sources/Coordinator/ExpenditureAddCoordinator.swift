//
//  ExpenditureAddCoordinator.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator
import Dependencies
import YBDependency
import Entity

public protocol ExpenditureAddCoordinatorDelegate: NSObject {
    func dismissRegisterExpense(editDate: Date)
    func dismissUpdateExpense(expenseItem: ExpenseItem)
}

final public class ExpenditureAddCoordinator: ExpenditureAddCoordinatorInterface {
    public var navigationController: UINavigationController
    public var expenditureEditNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: ExpenditureCoordinatorInterface?
    public weak var delegate: ExpenditureAddCoordinatorDelegate?
    public var expenditureAddViewController: ExpenditureAddViewController?
    public let expenseItem: ExpenseItem?
    public let tripItem: TripItem
    public let editDate: Date
    public let expenditureTab: ExpenditureTab
    public let expenseDetail: ExpenseDetailItem?
    public let hasSharedBudget: Bool

    public init(
        navigationController: UINavigationController,
        expenseItem: ExpenseItem?,
        tripItem: TripItem,
        editDate: Date,
        expenditureTab: ExpenditureTab,
        expenseDetail: ExpenseDetailItem?,
        hasSharedBudget: Bool
    ) {
        self.navigationController = navigationController
        self.expenseItem = expenseItem
        self.tripItem = tripItem
        self.editDate = editDate
        self.expenditureTab = expenditureTab
        self.expenseDetail = expenseDetail
        self.hasSharedBudget = hasSharedBudget
    }

    public func start(animated: Bool) {
        let expenditureAddViewController = ExpenditureAddViewController(
            coordinator: self, 
            expenseItem: expenseItem,
            tripItem: tripItem,
            editDate: editDate, 
            expenditureTab: expenditureTab,
            expenseDetail: expenseDetail,
            hasSharedBudget: hasSharedBudget
        )
        self.expenditureAddViewController = expenditureAddViewController
        expenditureEditNavigationController = UINavigationController(rootViewController: expenditureAddViewController)
        expenditureEditNavigationController?.modalPresentationStyle = .overFullScreen
        navigationController.present(expenditureEditNavigationController!, animated: animated)
    }

    public func dismissRegisterExpense() {
        delegate?.dismissRegisterExpense(editDate: editDate)
        coordinatorDidFinish()
    }

    public func dismissUpdateExpense(expenseItem: ExpenseItem) {
        coordinatorDidFinish()
        delegate?.dismissUpdateExpense(expenseItem: expenseItem)
    }

    public func popDidFinish() {
        expenditureEditNavigationController?.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        expenditureAddViewController = nil
        expenditureEditNavigationController?.dismiss(animated: true)
        expenditureEditNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("ExpenditureAddCoordinator is de-initialized.")
    }
}

extension ExpenditureAddCoordinator {

    public func pushCalculation(expenseType: ExpenditureType, tripItem: TripItem,  expenseDetail: ExpenseDetailItem) {
        let calculationViewController = CalculationViewController(
            coordinator: self, 
            expenseType: expenseType,
            tripItem: tripItem,
            expenseDetail: expenseDetail,
            hasSharedBudget: hasSharedBudget
        )
        expenditureEditNavigationController?.pushViewController(calculationViewController, animated: true)
    }

    public func setCalculationData(expenseDetail: ExpenseDetailItem, expenseType: ExpenditureType) {
        expenditureAddViewController?.setCalculationData(expenseDetail: expenseDetail, expenseType: expenseType)
        expenditureEditNavigationController?.popViewController(animated: true)
    }

    public func showCurrencyBottomSheet(currenyList: [Currency], selectedCurrency: Currency, expenseType: ExpenseType) {
        let currencyBottomSheetViewController = CurrencyBottomSheetViewController(
            coordinator: self,
            currenyList: currenyList, 
            selectedCurrency: selectedCurrency,
            expenseType: expenseType
        )
        expenditureEditNavigationController?.presentBottomSheet(
            presentedViewController: currencyBottomSheetViewController,
            height: 310
        )
    }

    public func selectCurrency(curreny: Currency, expenseType: ExpenseType) {
        expenditureAddViewController?.selectCurrency(currency: curreny, expenseType: expenseType)
        expenditureEditNavigationController?.dismiss(animated: true)
    }
}
