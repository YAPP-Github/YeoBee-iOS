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
    public let tripId: Int
    public let editDate: Date

    public init(navigationController: UINavigationController, tripId: Int, editDate: Date) {
        self.navigationController = navigationController
        self.tripId = tripId
        self.editDate = editDate
    }

    public func start(animated: Bool) {
        let expenditureAddViewController = ExpenditureAddViewController(
            coordinator: self,
            tripId: tripId,
            editDate: editDate
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
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}

extension ExpenditureAddCoordinator {
    public func showCurrencyBottomSheet(currenyList: [Currency]) {
        let currencyBottomSheetViewController = CurrencyBottomSheetViewController(
            coordinator: self,
            currenyList: currenyList
        )
        expenditureEditNavigationController?.presentBottomSheet(
            presentedViewController: currencyBottomSheetViewController,
            height: 310
        )
    }

    public func selectCurrency(curreny: Currency) {
        expenditureAddViewController?.selectCurrency(currency: curreny)
        expenditureEditNavigationController?.dismiss(animated: true)
    }
}
