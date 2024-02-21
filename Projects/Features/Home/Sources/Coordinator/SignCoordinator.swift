//
//  SignCoordinator.swift
//  YeoBee
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator

final public class SignCoordinator: SignCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = false) {
        let signViewController = SignViewController()
        viewControllerRef = signViewController
        let signReactor = SignReactor()
        signViewController.reactor = signReactor
        signViewController.coordinator = self
        navigationController.pushViewController(signViewController, animated: animated)
    }

  public func startWithInit(animated: Bool = false) {
      let signViewController = SignViewController()
      viewControllerRef = signViewController
      let signReactor = SignReactor()
      signViewController.reactor = signReactor
      signViewController.coordinator = self
    navigationController.setViewControllers([signViewController], animated: true)
  }
  
    public func createAccount() {
        let createCoodinator = CreateAccountCoordinator(navigationController: self.navigationController)
        self.addChild(createCoodinator)
        createCoodinator.start(animated: true)
    }

    public func home() {
        let homeCoordinator = HomeCoordinator(navigationController: self.navigationController)
        self.addChild(homeCoordinator)
        homeCoordinator.start(animated: true)
    }

}

