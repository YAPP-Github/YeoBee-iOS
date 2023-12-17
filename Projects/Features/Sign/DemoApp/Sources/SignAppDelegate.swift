//  SignAppDelegate.swift
//  SignDemoApp
//
//  Created by 이호영
//

import UIKit
import Sign

@main
class SignAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = SignViewController()
    self.window?.makeKeyAndVisible()
    return true
  }
}


