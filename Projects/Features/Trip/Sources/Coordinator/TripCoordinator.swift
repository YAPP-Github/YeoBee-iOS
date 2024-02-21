//
//  TripCoordinator.swift
//  Trip
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator
import Entity
import Expenditure
import DesignSystem

public protocol TripCoordinatorDelegate: AnyObject {
    func deletedTrip()
}

final public class TripCoordinator: TripCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    public var tabBarController: UITabBarController?
    public var childCoordinators = [Coordinator]()
    public var parent: HomeCoordinatorInterface?
    public let tripItem: TripItem
    public weak var delegate: TripCoordinatorDelegate?

    public init(navigationController: UINavigationController, tripItem: TripItem) {
        self.navigationController = navigationController
        self.tripItem = tripItem
    }

    public func start(animated: Bool = false) {
        let expenditureCoordinator = ExpenditureCoordinator(navigationController: UINavigationController(), tripItem: tripItem)
        expenditureCoordinator.delegate = self
        expenditureCoordinator.parent = self
        addChild(expenditureCoordinator)

        let calculationCoordinator = CalculationCoordinator(navigationController: UINavigationController(), tripItem: tripItem)
        calculationCoordinator.parent = self
        addChild(calculationCoordinator)

        expenditureCoordinator.start(animated: false)
        calculationCoordinator.start(animated: false)
        tabBarController = UITabBarController()

        guard let expenditureNavigationController = expenditureCoordinator.expenditureNavigationController else { return  }
        guard let calculationNavigationController = calculationCoordinator.calculationNavigationController else { return  }

        calculationNavigationController.tabBarItem.title = "정산"
        calculationNavigationController.tabBarItem.image = DesignSystemAsset.Icons.accountBook.image
        calculationNavigationController.toolbar.barTintColor = YBColor.black.color
        calculationNavigationController.tabBarItem.badgeColor = YBColor.gray5.color
        calculationNavigationController.toolbar.tintColor = YBColor.black.color
        tabBarController?.viewControllers = [expenditureNavigationController, calculationNavigationController]
        tabBarController?.modalPresentationStyle = .overFullScreen

        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().unselectedItemTintColor = YBColor.gray5.color
        UITabBar.appearance().backgroundColor = .white
        navigationController.present(tabBarController!, animated: true)
    }

    public func coordinatorDidFinish() {
        tabBarController?.dismiss(animated: true)
        tabBarController = nil
        parent?.childDidFinish(self)
    }

    deinit {
        print("TripCoordinator is de-initialized.")
    }
}

extension TripCoordinator: ExpenditureCoordinatorDelegate {
    public func deletedTrip() {
        delegate?.deletedTrip()
    }
}
