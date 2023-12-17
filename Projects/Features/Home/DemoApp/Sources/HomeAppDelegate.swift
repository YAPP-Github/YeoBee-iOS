//
//  HomeAppDelegate.swift
//  HomeDemoApp
//
//  Created by 이호영 on 
//

import UIKit
import Home

@main
class HomeAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = HomeViewController()
    self.window?.makeKeyAndVisible()
    return true
  }
}

