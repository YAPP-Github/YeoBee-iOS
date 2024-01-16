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

final public class ExpenditureCoordinator: NSObject, ExpenditureCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var expenditureNavigationController: UINavigationController?

    public var parent: TripCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let expenditureViewController = ExpenditureViewController(coordinator: self)
        expenditureNavigationController = UINavigationController(rootViewController: expenditureViewController)
    }

    public func coordinatorDidFinish() {
        expenditureNavigationController = nil
        parent?.coordinatorDidFinish()
        parent?.childDidFinish(self)
    }

    deinit {
        print("ExpenditureCoordinator is de-initialized.")
    }
}

extension ExpenditureCoordinator {

    public func expenditureEdit() {
        let expenditureEditCoordinator = ExpenditureEditCoordinator(navigationController: expenditureNavigationController!)
        expenditureEditCoordinator.parent = self
        addChild(expenditureEditCoordinator)
        expenditureEditCoordinator.start(animated: true)
    }
}
