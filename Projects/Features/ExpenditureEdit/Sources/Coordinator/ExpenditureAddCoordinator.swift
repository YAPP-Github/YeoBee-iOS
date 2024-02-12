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
        expenditureEditNavigationController?.dismiss(animated: true)
        expenditureEditNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}
