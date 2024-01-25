//
//  TravelRegistrationAppDelegate.swift
//  TravelRegistrationDemoApp
//
//  Created by 박현준 on 
//

import UIKit
import TravelRegistration

@main
class TravelRegistrationAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let coordinator = TravelRegistrationCoordinator(navigationController: navigationController)
        coordinator.start(animated: false)

        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
}

