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
    
    let stackView = UIStackView()
    let titleLabel = YBLabel(text: "여행 경비 기록부터 정산까지", font: .title1, textColor: .gray6)
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.Icons.logo.image
        return imageView
    }()
    let illustImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.Icons.focusBee.image
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
        stackView.axis = .vertical
        stackView.alignment = .center

        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(illustImageView)

        stackView.setCustomSpacing(20, after: titleLabel)
        stackView.setCustomSpacing(70, after: logoImageView)

        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }

        illustImageView.snp.makeConstraints { make in
            make.height.width.equalTo(120)
            make.centerX.equalToSuperview()
        }
    }
    
    private func transitionToMainViewController() {
        guard let splashNavigationController = self.navigationController else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
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
