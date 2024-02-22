//
//  SceneDelegate.swift
//  YeoBee
//
//  Created by 이호영 on 2023/12/12.
//

import UIKit
import Expenditure
import ComposableArchitecture
import UseCase
import Repository
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        let tokenRepository = TokenRepository.shared
        
        navigationController.hidesBottomBarWhenPushed = true
        
        Task {
            let isTokenExpiring = try await tokenRepository.isTokenExpiring()
            var isOnboardingCompleted: Bool? = nil
            do {
                isOnboardingCompleted = try await UserInfoRepository().isOnboardingCompleted()
                DispatchQueue.main.async {
                    let coordinator = RootCoordinator(
                        navigationController: navigationController,
                        isTokenExpring: isTokenExpiring,
                        isOnboardingCompleted: isOnboardingCompleted
                    )
                    coordinator.start(animated: false)
                    
                    self.window?.overrideUserInterfaceStyle = .light
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
                
            } catch {
                DispatchQueue.main.async {
                    let coordinator = RootCoordinator(
                        navigationController: navigationController,
                        isTokenExpring: false,
                        isOnboardingCompleted: false
                    )
                    coordinator.sign(navigationController: navigationController)
                    
                    self.window?.overrideUserInterfaceStyle = .light
                    self.window?.rootViewController = navigationController
                    self.window?.makeKeyAndVisible()
                }
                return // 이후 코드 실행 방지
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

