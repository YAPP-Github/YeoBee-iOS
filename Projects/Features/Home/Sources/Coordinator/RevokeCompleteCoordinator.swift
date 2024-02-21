//
//  RevokeCompleteCoordinator.swift
//  Home
//
//  Created by 김태형 on 2/22/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Coordinator
import UIKit
import Entity

final public class RevokeCompleteCoordinator: RevokeCoordinatorInterface {
    public var navigationController: UINavigationController
    public var myPageNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start(animated: Bool = false) {
        let revokeCompleteViewController = RevokeCompleteViewController()
        let reactor = RevokeCompleteReactor()
        revokeCompleteViewController.reactor = reactor
        revokeCompleteViewController.coordinator = self
        navigationController.pushViewController(revokeCompleteViewController, animated: true)
    }
    
    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }
    
    public func login() {
        let signCoordinator = SignCoordinator(navigationController: self.navigationController)
        signCoordinator.addChild(self)
        signCoordinator.startWithInit()
    }
    
    deinit {
        print("CreateAccountCoordinator is de-initialized.")
    }
}
