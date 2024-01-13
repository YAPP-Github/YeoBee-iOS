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

final public class ExpenditureCoordinator: NSObject, ParentCoordinator, Coordinator {

    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let expenditureViewController = ExpenditureViewController()
        expenditureViewController.coordinator = self
        navigationController.pushViewController(expenditureViewController, animated: false)
    }
}
