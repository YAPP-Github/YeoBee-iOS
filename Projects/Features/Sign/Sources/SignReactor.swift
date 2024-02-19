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
    }
    
    public enum Mutation {
        case setLoginStatus(Bool)
    }
    
    public struct State {
        var isLoginSuccess: Bool
    }
    
    public let initialState: State
    
    public init(
        isLoginSuccess: Bool
    ) {
        self.initialState = .init(
            isLoginSuccess: isLoginSuccess
        )
    }
    
    let authRepository = LoginRepository()
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .kakao:
                return Observable.create { observer in
                    Task {
                        do {
                            let isSuccess = try await self.kakaoLogin()
                            observer.onNext(.setLoginStatus(isSuccess))
                        } catch {
                            observer.onNext(.setLoginStatus(false))
                        }
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            case .appleLogin(let code, let idToken):
                return Observable.create { observer in
                    Task {
                        do {
                            let isSuccess = try await self.appleLogin(code: code, idToken: idToken)
                            observer.onNext(.setLoginStatus(isSuccess))
                        } catch {
                            observer.onNext(.setLoginStatus(false))
                        }
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
                
            case .appleLoginFailure:
                return Observable.just(.setLoginStatus(false))
        }
        
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            case .setLoginStatus(let isSuccess):
                newState.isLoginSuccess = isSuccess
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
