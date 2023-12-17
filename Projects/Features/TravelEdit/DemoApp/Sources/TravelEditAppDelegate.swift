//
//  TravelEditAppDelegate.swift
//  TravelEditDemoApp
//
//  Created by 이호영 on 
//

import UIKit
import TravelEdit

@main
class TravelEditAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = TravelEditViewController()
    self.window?.makeKeyAndVisible()
    return true
  }
}

