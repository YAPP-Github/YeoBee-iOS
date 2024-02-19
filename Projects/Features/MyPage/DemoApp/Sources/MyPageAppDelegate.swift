//
//  MyPageAppDelegate.swift
//  MyPageDemoApp
//
//  Created by Hoyoung Lee on 
//

import UIKit
import MyPage

@main
class MyPageAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = TripViewController()
    self.window?.makeKeyAndVisible()
    return true
  }
}

