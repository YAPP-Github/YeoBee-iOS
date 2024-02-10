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

final class RootCoordinator: NSObject, Coordinator, ParentCoordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(animated: Bool) {
        /// 토큰 처리
//        if true {
        sign(navigationController: navigationController)
//        } else {
//            home(navigationController: navigationController)
//        }
//        home(navigationController: navigationController)
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
}
