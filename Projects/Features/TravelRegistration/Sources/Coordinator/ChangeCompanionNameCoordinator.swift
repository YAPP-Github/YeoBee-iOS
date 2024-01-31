//
//  ChangeCompanionNameCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/26/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Entity
import Coordinator

final public class ChangeCompanionNameCoordinator: NSObject, ChangeCompanionNameCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var ChangeCompanionNameNavigationController: UIViewController?

    public var parent: CompanionCoordinatorInterface?
    public let index: IndexPath
    public let tripUserItemRequest: TripUserItemRequest

    public init(navigationController: UINavigationController, index: IndexPath, tripUserItemRequest: TripUserItemRequest) {
        self.navigationController = navigationController
        self.index = index
        self.tripUserItemRequest = tripUserItemRequest
    }

    public func start(animated: Bool) {
        let changeCompanionNameReactor = ChangeCompanionNameReactor(tripUserItemRequest: tripUserItemRequest, index: index)
        let changeCompanionNameVC = ChangeCompanionNameViewController(coordinator: self, reactor: changeCompanionNameReactor)
        navigationController.pushViewController(changeCompanionNameVC, animated: true)
    }

    public func coordinatorDidFinish() {
        ChangeCompanionNameNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("ChangeCompanionNameCoordinator is de-initialized.")
    }
}

extension ChangeCompanionNameCoordinator {
    public func companion(index: IndexPath, tripUserItemRequest: TripUserItemRequest) {
        // changeCompanionViewController가 dismiss 되면서 기존에 companionCoordinator에 값 전달
        parent?.changedCompanionName(index: index, tripUserItemRequest: tripUserItemRequest)
        coordinatorDidFinish()
    }
}
