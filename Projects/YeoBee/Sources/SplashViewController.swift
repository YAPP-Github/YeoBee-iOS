//
//  SplashViewController.swift
//  YeoBee
//
//  Created by 김태형 on 2/24/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Repository

class SplashViewController: UIViewController {
    let tokenRepository = TokenRepository.shared
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.Icons.launchScreen.image
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setLayouts()
        transitionToMainViewController()
    }
   
    
    private func setLayouts() {
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
        }
    }
    
    private func transitionToMainViewController() {
        guard let splashNavigationController = self.navigationController else {
            return
        }
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          Task {
              let isTokenExpiring = try await self.tokenRepository.isTokenExpiring()
              var isOnboardingCompleted: Bool? = nil
              do {
                  isOnboardingCompleted = try await UserInfoRepository().isOnboardingCompleted()
                  DispatchQueue.main.async {
                      let coordinator = RootCoordinator(
                        navigationController: splashNavigationController,
                          isTokenExpring: isTokenExpiring,
                          isOnboardingCompleted: isOnboardingCompleted
                      )
                      coordinator.start(animated: false)
                      
                  }
                  
              } catch {
                  DispatchQueue.main.async {
                      let coordinator = RootCoordinator(
                          navigationController: splashNavigationController,
                          isTokenExpring: false,
                          isOnboardingCompleted: false
                      )
                      coordinator.sign(navigationController: splashNavigationController)
                      
                  }
                  return // 이후 코드 실행 방지
              }
          }
      }
    }
}
