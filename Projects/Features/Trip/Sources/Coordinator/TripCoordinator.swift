//
//  TripCoordinator.swift
//  Trip
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator
import Expenditure
import DesignSystem

final public class TripCoordinator: TripCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    public var tabBarController: UITabBarController?
    public var childCoordinators = [Coordinator]()
    public var parent: HomeCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = false) {
        let expenditureCoordinator = ExpenditureCoordinator(navigationController: UINavigationController())
        expenditureCoordinator.parent = self
        addChild(expenditureCoordinator)

        expenditureCoordinator.start(animated: false)
        tabBarController = UITabBarController()

        guard let expenditureNavigationController = expenditureCoordinator.expenditureNavigationController else { return  }

        tabBarController?.viewControllers = [expenditureNavigationController]
        tabBarController?.modalPresentationStyle = .overFullScreen

        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().backgroundColor = .white
        navigationController.present(tabBarController!, animated: true)
    }

    public func coordinatorDidFinish() {
        tabBarController?.dismiss(animated: true)
        tabBarController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("TripCoordinator is de-initialized.")
    }
}
