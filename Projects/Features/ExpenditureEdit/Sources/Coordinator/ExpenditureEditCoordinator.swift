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
    public let expenditureTab: ExpenditureTab

    public init(
        navigationController: UINavigationController,
        tripItem: TripItem,
        expenseDetail: ExpenseDetailItem,
        expenditureTab: ExpenditureTab
    ) {
        self.navigationController = navigationController
        self.tripItem = tripItem
        self.expenseDetail = expenseDetail
        self.expenditureTab = expenditureTab
    }

    public func start(animated: Bool) {
        let expenditureUpdateViewController = ExpenditureUpdateViewController(
            coordinator: self,
            tripItem: tripItem,
            expenseDetail: expenseDetail,
            expenditureTab: expenditureTab
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

//extension ExpenditureEditCoordinator {
//
//    public func pushCalculation(expenseType: ExpenditureType, tripItem: TripItem,  expenseDetail: ExpenseDetailItem) {
//        let calculationViewController = CalculationViewController(
//            coordinator: self,
//            expenseType: expenseType,
//            tripItem: tripItem,
//            expenseDetail: expenseDetail
//        )
//        expenditureEditNavigationController?.pushViewController(calculationViewController, animated: true)
//    }
//
//    public func setCalculationData(expenseDetail: ExpenseDetailItem, expenseType: ExpenditureType) {
//        expenditureAddViewController?.setCalculationData(expenseDetail: expenseDetail, expenseType: expenseType)
//        expenditureEditNavigationController?.popViewController(animated: true)
//    }
//
//    public func showCurrencyBottomSheet(currenyList: [Currency], selectedCurrency: Currency, expenseType: ExpenseType) {
//        let currencyBottomSheetViewController = CurrencyBottomSheetViewController(
//            coordinator: self,
//            currenyList: currenyList,
//            selectedCurrency: selectedCurrency,
//            expenseType: expenseType
//        )
//        expenditureEditNavigationController?.presentBottomSheet(
//            presentedViewController: currencyBottomSheetViewController,
//            height: 310
//        )
//    }
//
//    public func selectCurrency(curreny: Currency, expenseType: ExpenseType) {
//        expenditureAddViewController?.selectCurrency(currency: curreny, expenseType: expenseType)
//        expenditureEditNavigationController?.dismiss(animated: true)
//    }
//}
