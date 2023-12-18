//
//  OnboardingAppDelegate.swift
//  OnboardingDemoApp
//
//  Created by 이호영
//

import UIKit
import Onboarding

@main
class OnboardingAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = OnboardingViewController()
    self.window?.makeKeyAndVisible()
    return true
  }
}

