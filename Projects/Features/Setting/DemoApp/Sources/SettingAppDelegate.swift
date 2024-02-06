//
//  SettingAppDelegate.swift
//  SettingDemoApp
//
//  Created by 박현준 on 
//

import UIKit
import Setting

@main
class SettingAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        let settingReactor = SettingReactor()
        let settingViewController = SettingViewController(coordinator: settingCoordinator, reactor: settingReactor)
        
        self.window?.rootViewController = settingViewController
        self.window?.makeKeyAndVisible()
        return true
    }
}

