//
//  CompanionCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import Coordinator

protocol CompanionCoordinatorDelegate: AnyObject {
    func changedComanionName(index: IndexPath, tripUserItemRequest: TripUserItemRequest)
}

final public class CompanionCoordinator: NSObject, CompanionCoordinatorInterface {
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var navigationController: UINavigationController
    public var companionNavigationController: UIViewController?

    public var parent: CalendarCoordinatorInterface?
    public let tripRequest: TripRequest
    weak var delegate: CompanionCoordinatorDelegate?

    public init(navigationController: UINavigationController, tripRequest: TripRequest) {
        self.navigationController = navigationController
        self.tripRequest = tripRequest
    }

    public func start(animated: Bool) {
        let companionReactor = CompanionReactor(tripRequest: tripRequest)
        let companionViewController = CompanionViewController(coordinator: self, reactor: companionReactor)
        companionNavigationController = companionViewController
        navigationController.pushViewController(companionNavigationController!, animated: animated)
    }

    public func coordinatorDidFinish() {
        companionNavigationController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("CompanionCoordinator is de-initialized.")
    }
}

extension CompanionCoordinator {
    public func changeCompanionName(index: IndexPath, tripUserItemRequest: TripUserItemRequest) {
        let changeCompanionCoordinator = ChangeCompanionNameCoordinator(navigationController: navigationController,
                                                         index: index,
                                                         tripUserItemRequest: tripUserItemRequest)
        changeCompanionCoordinator.parent = self
        addChild(changeCompanionCoordinator)
        changeCompanionCoordinator.start(animated: true)
    }
    
    public func travelTitle(tripRequest: TripRequest) {
        let travelTitleCoordinator = TravelTitleCoordinator(navigationController: navigationController,
                                                            tripRequest: tripRequest)
        travelTitleCoordinator.parent = self
        addChild(travelTitleCoordinator)
        travelTitleCoordinator.start(animated: true)
    }
    
    public func changedCompanionName(index: IndexPath, tripUserItemRequest: TripUserItemRequest) {
        // companion 이름 변경된 데이터 companionViewController로 주입
        delegate?.changedComanionName(index: index, tripUserItemRequest: tripUserItemRequest)
    }
}
