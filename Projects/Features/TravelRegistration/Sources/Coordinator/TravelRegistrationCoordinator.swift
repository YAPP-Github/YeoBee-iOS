//
//  TravelRegistrationCoordinator.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

import Coordinator
import Entity

public protocol TravelRegistrationCoordinatorDelegate: AnyObject {
    func finishedRegistration(tripItem: TripItem)
}

final public class TravelRegistrationCoordinator: TravelRegistrationCoordinatorInterface {
    public var navigationController: UINavigationController
    public var travelRegistrationNavigationController: UINavigationController?
    public var viewControllerRef: UIViewController?
    public var childCoordinators = [Coordinator]()
    public var parent: HomeCoordinatorInterface?
    public weak var delegate: TravelRegistrationCoordinatorDelegate?

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    public func start(animated: Bool) {
        let countryReactor = CountryReactor()
        let countryViewController = UINavigationController(
            rootViewController: CountryViewController(coordinator: self,reactor: countryReactor)
        )
        countryViewController.modalPresentationStyle = .overFullScreen
        travelRegistrationNavigationController = countryViewController
        navigationController.present(travelRegistrationNavigationController!, animated: animated)
    }

    public func coordinatorDidFinish() {
        travelRegistrationNavigationController = nil
        parent?.childDidFinish(self)
    }
    
    public func finishedRegistration(tripItem: TripItem) {
        delegate?.finishedRegistration(tripItem: tripItem)
        coordinatorDidFinish()
    }

    deinit {
        print("TravelRegistrationCoordinator is de-initialized.")
    }
}

extension TravelRegistrationCoordinator {
    public func startCalendar(tripRequest: RegistTripRequest) {
        let calendarReactor = CalendarReactor(tripRequest: tripRequest)
        let calendarViewController = CalendarViewController(coordinator: self, reactor: calendarReactor)
        travelRegistrationNavigationController?.pushViewController(calendarViewController, animated: true)
    }
    
    public func startCompanion(tripRequest: RegistTripRequest) {
        let companionReactor = CompanionReactor(tripRequest: tripRequest)
        let companionViewController = CompanionViewController(coordinator: self, reactor: companionReactor)
        travelRegistrationNavigationController?.pushViewController(companionViewController, animated: true)
    }
    
    public func startTravelTitle(tripRequest: RegistTripRequest) {
        let travelTtitleReactor = TravelTitleReactor(tripRequest: tripRequest)
        let travelTitleViewController = TravelTitleViewController(coordinator: self, reactor: travelTtitleReactor)
        travelRegistrationNavigationController?.pushViewController(travelTitleViewController, animated: true)
    }
}
