//
//  ExpenditureEditAppDelegate.swift
//  ExpenditureEditDemoApp
//
//  Created by Hoyoung Lee on 
//

import UIKit
import ExpenditureEdit

@main
class ExpenditureEditAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = ExpenditureEditViewController()
    self.window?.makeKeyAndVisible()
    return true
  }
}

