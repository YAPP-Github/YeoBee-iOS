//
//  RrotCoordinator.swift
//  YeoBee
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

import Coordinator
import Sign
import Home
import YBNetwork
import Repository

final class RootCoordinator: NSObject, Coordinator, ParentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var isTokenExpiring: Bool
    var isOnboardingCompleted: Bool?
    
    init(navigationController: UINavigationController,
         isTokenExpring: Bool,
         isOnboardingCompleted: Bool?
    ) {
        self.navigationController = navigationController
        self.isTokenExpiring = isTokenExpring
        self.isOnboardingCompleted = isOnboardingCompleted
    }

    func start(animated: Bool) {
        if isTokenExpiring {
            if let isOnboardingCompleted {
                home(navigationController: navigationController)
            } else {
                createAccount(navigationController: navigationController)
            }
        } else {
            sign(navigationController: navigationController)
        }
    }
}

extension RootCoordinator {

    func sign(navigationController: UINavigationController) {
        let signCoordinator = SignCoordinator(navigationController: navigationController)
        addChild(signCoordinator)
        signCoordinator.start()
    }

    func home(navigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        addChild(homeCoordinator)
        homeCoordinator.start()
    }
    
    func createAccount(navigationController: UINavigationController) {
        let createAccountCoordinator = CreateAccountCoordinator(navigationController: navigationController)
        addChild(createAccountCoordinator)
        createAccountCoordinator.start()
    }
}
