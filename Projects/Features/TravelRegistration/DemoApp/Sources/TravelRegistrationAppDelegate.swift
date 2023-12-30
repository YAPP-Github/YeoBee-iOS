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
    self.window?.rootViewController = UINavigationController(rootViewController: TravelRegistrationViewController())
    self.window?.makeKeyAndVisible()
    return true
  }
}

