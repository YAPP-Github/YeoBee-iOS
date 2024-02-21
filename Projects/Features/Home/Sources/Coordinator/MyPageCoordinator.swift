//
//  MyPageCoordinator.swift
//  Mypage
//
//  Created by 김태형 on 2/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Coordinator
import UIKit
import Entity

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
        navigationController.pushViewController(myPageViewController, animated: true)
    }
    
    public func popDidFinish() {
        navigationController.popViewController(animated: true)
    }
    
    public func editProfile(userInfo: FetchUserResponse?) {
        let editProfileVC = EditMyProfileViewController()
        let reactor = EditMyProfileReactor(userInfo: userInfo)
        editProfileVC.reactor = reactor
        self.navigationController.pushViewController(editProfileVC, animated: true)
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
