//
//  ExpenditureEditCoordinator.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator

final public class ExpenditureEditCoordinator: ExpenditureEditCoordinatorInterface {
    public var navigationController: UINavigationController
    public var expenditureEditNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: ExpenditureCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let expenditureEditViewController = ExpenditureEditViewController(coordinator: self)
        expenditureEditNavigationController = UINavigationController(rootViewController: expenditureEditViewController)
        expenditureEditNavigationController?.modalPresentationStyle = .overFullScreen
        navigationController.present(expenditureEditNavigationController!, animated: animated)
    }

    public func popDidFinish() {
        expenditureEditNavigationController?.popViewController(animated: true)
    }

    public func coordinatorDidFinish() {
        expenditureEditNavigationController?.dismiss(animated: true)
        parent?.childDidFinish(self)
    }

    deinit {
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}
