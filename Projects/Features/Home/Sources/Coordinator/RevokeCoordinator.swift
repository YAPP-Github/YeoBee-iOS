//
//  RevokeCoordinator.swift
//  Home
//
//  Created by 김태형 on 2/22/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Coordinator
import UIKit
import Entity

final public class RevokeCoordinator: RevokeCoordinatorInterface {
    public var navigationController: UINavigationController
    public var myPageNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start(animated: Bool = false) {
        let revokeViewController = RevokeViewController()
        let reactor = RevokeViewReactor()
        revokeViewController.reactor = reactor
        revokeViewController.coordinator = self
        navigationController.pushViewController(revokeViewController, animated: true)
    }
    
    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }
    
    public func login() {
        let signCoordinator = SignCoordinator(navigationController: self.navigationController)
        signCoordinator.addChild(self)
        signCoordinator.startWithInit()
    }
    
    public func revokeComplete() {
        let revokeCompleteCoordinator = RevokeCompleteCoordinator(navigationController: self.navigationController)
        revokeCompleteCoordinator.start()
    }
    
    deinit {
        print("CreateAccountCoordinator is de-initialized.")
    }
}
