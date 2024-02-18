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
}

final public class ExpenditureAddCoordinator: ExpenditureAddCoordinatorInterface {
    public var navigationController: UINavigationController
    public var expenditureEditNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: ExpenditureCoordinatorInterface?
    public weak var delegate: ExpenditureAddCoordinatorDelegate?
    public var expenditureAddViewController: ExpenditureAddViewController?
    public let tripItem: TripItem
    public let editDate: Date
    public let expenditureTab: ExpenditureTab

    public init(
        navigationController: UINavigationController,
        tripItem: TripItem,
        editDate: Date,
        expenditureTab: ExpenditureTab
    ) {
        self.navigationController = navigationController
        self.tripItem = tripItem
        self.editDate = editDate
        self.expenditureTab = expenditureTab
    }

    public func start(animated: Bool) {
        let expenditureAddViewController = ExpenditureAddViewController(
            coordinator: self,
            tripItem: tripItem,
            editDate: editDate, 
            expenditureTab: expenditureTab
        )
        self.expenditureAddViewController = expenditureAddViewController
        expenditureEditNavigationController = UINavigationController(rootViewController: expenditureAddViewController)
        expenditureEditNavigationController?.modalPresentationStyle = .overFullScreen
        navigationController.present(expenditureEditNavigationController!, animated: animated)
    }

    public func dismissRegisterExpense() {
        coordinatorDidFinish()
        delegate?.dismissRegisterExpense(editDate: editDate)
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
            expenseDetail: expenseDetail
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
