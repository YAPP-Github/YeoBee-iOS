//
//  SettingCoordinator.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator
import Entity

final public class SettingCoordinator: SettingCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: ExpenditureCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let settingReactor = SettingReactor()
        let settingViewController = SettingViewController(coordinator: self, reactor: settingReactor)
        navigationController.tabBarController?.tabBar.isHidden = true
        navigationController.pushViewController(settingViewController, animated: animated)
    }

    public func coordinatorDidFinish() {
        navigationController.popViewController(animated: true)
        navigationController.tabBarController?.tabBar.isHidden = false
        parent?.childDidFinish(self)
    }

    deinit {
        print("SettingCoordinator is de-initialized.")
    }
}
