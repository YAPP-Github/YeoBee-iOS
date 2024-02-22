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
        titleLabel.text = "모두를 위한 여행 정산 가계부"
        titleLabel.font = .ybfont(.title1)
        view.backgroundColor = YBColor.white.color
        illustImageView.image = DesignSystemAsset.Icons.illust.image
        logoImageView.image = DesignSystemAsset.Icons.logo.image
    }
    
    private func setLayouts() {
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        view.addSubview(illustImageView)
        view.addSubview(kakaoLoginButton)
        view.addSubview(appleLoginButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(146)
            make.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        illustImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(89)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.top.equalTo(illustImageView.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).offset(-48)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoLoginButton.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).offset(-48)
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
