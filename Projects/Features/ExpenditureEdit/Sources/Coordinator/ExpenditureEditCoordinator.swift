//
//  ExpenditureEditCoordinator.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator
import Dependencies
import YBDependency

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
    public let tripId: Int
    public let editDate: Date

    public init(navigationController: UINavigationController, tripId: Int, editDate: Date) {
        self.navigationController = navigationController
        self.tripId = tripId
        self.editDate = editDate
    }

    public func start(animated: Bool) {
        withDependencies {
            $0.yeoBeeDependecy()
        } operation: {
            let expenditureEditViewController = ExpenditureEditViewController(
                coordinator: self,
                tripId: tripId,
                editDate: editDate
            )
            expenditureEditNavigationController = UINavigationController(rootViewController: expenditureEditViewController)
            expenditureEditNavigationController?.modalPresentationStyle = .overFullScreen
            navigationController.present(expenditureEditNavigationController!, animated: animated)
        }
    }

    public func dismissRegisterExpense() {
        coordinatorDidFinish()
        delegate?.dismissRegisterExpense(editDate: editDate)
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
