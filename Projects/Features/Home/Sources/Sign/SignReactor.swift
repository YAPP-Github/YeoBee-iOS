//
//  SignReactor.swift
//  Sign
//
//  Created by 김태형 on 2/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import KakaoSDKAuth
import KakaoSDKUser
import Repository

import YBNetwork
import AuthenticationServices

public final class SignReactor: Reactor {
    public enum Action  {
        case kakao
        case appleLogin(code: Data, idToken: Data)
        case appleLoginFailure
        case loginSuccess
    }
    
    public enum Mutation {
        case setOnboardingCompleted(Bool)
    }
    
    public struct State {
        var isOnBoardingCompleted: Bool?
    }
    
    public let initialState: State
    
    public init() {
        self.initialState = .init()
    }
    
    let authRepository = LoginRepository()
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .kakao:
                return Observable.create { observer in
                    Task {
                        do {
                            try await self.kakaoLogin()
                            let isOnboardingCompleted = try await UserInfoRepository().isOnboardingCompleted()
                            observer.onNext(.setOnboardingCompleted(isOnboardingCompleted))
                        } catch {
                            //TODO: 에러처리
                        }
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            case .appleLogin(let code, let idToken):
                return Observable.create { observer in
                    Task {
                        do {
                            try await self.appleLogin(code: code, idToken: idToken)
                            let isOnboardingCompleted = try await UserInfoRepository().isOnboardingCompleted()
                            observer.onNext(.setOnboardingCompleted(isOnboardingCompleted))
                        } catch {
                            //TODO: 에러처리
                        }
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
                
            case .appleLoginFailure:
                return Observable.empty()
                
            case .loginSuccess:
                return Observable.just(.setOnboardingCompleted(true))
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            case .setOnboardingCompleted(let isCompleted):
                newState.isOnBoardingCompleted = isCompleted
        }
        
        return newState
    }
    
    private func kakaoLogin() async throws -> Bool {
        let oauthToken = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<OAuthToken, Error>) in
            DispatchQueue.main.async {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let oauthToken = oauthToken {
                            continuation.resume(returning: oauthToken)
                        }
                    }
                } else {
                    UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let oauthToken = oauthToken {
                            continuation.resume(returning: oauthToken)
                        }
                    }
                }
            }
        }
        
        let tokens = try await authRepository.loginWithKakao(token: oauthToken.accessToken)
        KeychainManager.shared.add(key: KeychainManager.accessToken, value: tokens.accessToken)
        KeychainManager.shared.add(key: KeychainManager.refreshToken, value: tokens.refreshToken)
        return true
    }
    
    private func appleLogin(code:Data, idToken: Data) async throws -> Bool {
        guard let idToken = String(data: idToken, encoding: .utf8), let code = String(data: code, encoding: .utf8) else { return false }
        
        let tokens = try await authRepository.loginWithApple(code: code, idToken: idToken)
        KeychainManager.shared.add(key: KeychainManager.accessToken, value: tokens.accessToken)
        KeychainManager.shared.add(key: KeychainManager.refreshToken, value: tokens.refreshToken)
        return true
    }
}
