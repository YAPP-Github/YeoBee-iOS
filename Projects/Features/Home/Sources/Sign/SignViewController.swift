//
//  SignViewController.swift
//  SignDemoApp
//
//  Created by 이호영
//

import UIKit
import Coordinator
import ReactorKit
import RxSwift
import RxCocoa
import Coordinator
import DesignSystem
import SnapKit
import YBNetwork
import AuthenticationServices

public final class SignViewController: UIViewController, View {
    public var coordinator: SignCoordinator?
    public var disposeBag: DisposeBag = DisposeBag()
    var appleLoginContinuation: CheckedContinuation<Bool, Error>?
    
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let logoImageView = UIImageView()
    let illustImageView = UIImageView()
    let kakaoLoginButton = YBIconWithTextButton(text: "카카오로 시작하기", appearance: .kakao)
    let appleLoginButton = YBIconWithTextButton(text: "Apple로 시작하기", appearance: .apple)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setLayouts()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(reactor: SignReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SignReactor) {
        kakaoLoginButton.rx.tap
            .map{ .kakao }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.appleLogin()
            })
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SignReactor) {
      reactor.state.compactMap { $0.isOnBoardingCompleted }
        .distinctUntilChanged()
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { isComplete in
          if isComplete {
            self.coordinator?.home()
          } else {
            self.coordinator?.createAccount()
          }
        })
    }
    
    private func setupViews() {
        stackView.axis = .vertical
        stackView.alignment = .center
        titleLabel.text = "여행 경비 정산 가계부"
        titleLabel.font = .ybfont(.header2)
        view.backgroundColor = YBColor.white.color
        illustImageView.image = DesignSystemAsset.Icons.illust.image
        logoImageView.image = DesignSystemAsset.Icons.logo.image
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setLayouts() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(illustImageView)
        stackView.addArrangedSubview(kakaoLoginButton)
        stackView.addArrangedSubview(appleLoginButton)
        
        stackView.setCustomSpacing(20, after: titleLabel)
        stackView.setCustomSpacing(85, after: logoImageView)
        stackView.setCustomSpacing(40, after: illustImageView)
        stackView.setCustomSpacing(20, after: kakaoLoginButton)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
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
            make.height.equalTo(167)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).offset(-48)
            make.height.equalTo(54)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).offset(-48)
            make.height.equalTo(54)
        }
    }
    
    private func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension SignViewController: ASAuthorizationControllerDelegate {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let idToken = credential.identityToken, let code = credential.authorizationCode else {
                return
            }
            reactor?.action.onNext(.appleLogin(code: code, idToken: idToken))
        }
    }

    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        reactor?.action.onNext(.appleLoginFailure)
    }
}

extension SignViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
