//
//  HomeCoordinator.swift
//  Home
//
//  Created by Hoyoung Lee on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator
import Entity
import TravelRegistration
import Trip
import Repository

public protocol HomeCoordinatorDelegate: AnyObject {
    func finishedRegistration(tripItem: TripItem)
    func deletedTrip()
}

final public class HomeCoordinator: HomeCoordinatorInterface {
    public var navigationController: UINavigationController
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public weak var delegate: HomeCoordinatorDelegate?
    public var homeViewController: HomeViewController?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool = false) {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        self.homeViewController = homeViewController

        if let tripItem = UserDefaultsRepository.liveValue.value(forKey: .lastShowingTrip),
           let tripItem = tripItem {
            lasttrip(tripItem: tripItem)
        } else {
            navigationController.pushViewController(homeViewController, animated: animated)
        }
    }
}

extension HomeCoordinator {
    public func travelRegisteration() {
        let countryCoordinator = TravelRegistrationCoordinator(navigationController: navigationController)
        countryCoordinator.delegate = self
        countryCoordinator.parent = self
        addChild(countryCoordinator)
        countryCoordinator.start(animated: true)
    }
    
    public func moreTrip(tripType: TripType) {
        let moreTripReactor = MoreTripReactor(tripType: tripType)
        let moreTripViewController = MoreTripViewController(coordinator: self, reactor: moreTripReactor)
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(moreTripViewController, animated: true)
    }

    public func trip(tripItem: TripItem, animated: Bool = true) {
        let tripCoordinator = TripCoordinator(navigationController: navigationController, tripItem: tripItem)
        tripCoordinator.delegate = self
        tripCoordinator.parent = self
        addChild(tripCoordinator)
        tripCoordinator.start(animated: animated)
    }

    public func lasttrip(tripItem: TripItem, animated: Bool = true) {
        if let homeViewController {
            let tripCoordinator = TripCoordinator(navigationController: navigationController, tripItem: tripItem)
            tripCoordinator.delegate = self
            tripCoordinator.parent = self
            addChild(tripCoordinator)
            navigationController.pushViewController(homeViewController, animated: animated)
            tripCoordinator.start(animated: false)
        }
    }

    public func myPage() {
        let myPageCoordinator = MyPageCoordinator(navigationController: navigationController)
          addChild(self)
      myPageCoordinator.start(animated: true)
    }
}

extension HomeCoordinator: TravelRegistrationCoordinatorDelegate {
    public func finishedRegistration(tripItem: TripItem) {
        delegate?.finishedRegistration(tripItem: tripItem)
    }
}

extension HomeCoordinator: TripCoordinatorDelegate {
    public func deletedTrip() {
        // 스플래시, 홈 포함 뷰 스택 2개
        let targetViewControllers = Array(navigationController.viewControllers.prefix(2))
        navigationController.setViewControllers(targetViewControllers, animated: true)
        delegate?.deletedTrip()
    }
}
