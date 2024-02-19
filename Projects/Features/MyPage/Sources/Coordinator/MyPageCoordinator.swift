//
//  MyPageCoordinator.swift
//  Mypage
//
//  Created by 김태형 on 2/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Coordinator
import UIKit

final public class MyPageCoordinator: MyPageCoordinatorInterface {
    public var navigationController: UINavigationController
    public var myPageNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    
    public init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
    
    public func start(animated: Bool = false) {
        let myPageViewController = MyPageViewController()
        let reactor = MyPageReactor()
        myPageViewController.reactor = reactor
        myPageViewController.coordinator = self
    }
    
    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }
    
    //    public func login() {
    //        let signCoordinator = SignCoordinator(navigationController: self.navigationController)
    //        signCoordinator.start(animated: true)
    //    }
    //    
    deinit {
        print("CreateAccountCoordinator is de-initialized.")
    }
}
