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
    public var settingNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: ExpenditureCoordinatorInterface?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let settingReactor = SettingReactor()
        let settingViewController = UINavigationController(
            rootViewController: SettingViewController(coordinator: self, reactor: settingReactor)
        )
        settingViewController.modalPresentationStyle = .overFullScreen
        settingNavigationController = settingViewController
        navigationController.present(settingNavigationController!, animated: animated)
    }

    public func coordinatorDidFinish() {
        settingNavigationController?.dismiss(animated: true)
        settingNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("SettingCoordinator is de-initialized.")
    }
}
