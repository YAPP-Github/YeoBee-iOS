//
//  AuthRepository.swift
//  Repository
//
//  Created by 김태형 on 2/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity

public protocol LoginRepositoryInterface {
    func loginWithKakao(token: String) async throws -> AuthTokenResponse
    func loginWithApple(code: String, idToken: String) async throws -> AuthTokenResponse
    func logout()
}

final public class LoginRepository: LoginRepositoryInterface {
    
    public init() {}
    
    let provider = MoyaProvider<LoginService>(plugins: [NetworkLogger()])
    
    public func loginWithKakao(token: String) async throws -> AuthTokenResponse {
        let response = try await provider.request(.kakaoLogin(token: token)).get()
        let authTokenResponse = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
        
        return authTokenResponse
    }
    
    public func loginWithApple(code: String, idToken: String) async throws -> AuthTokenResponse {
        let response = try await provider.request(.appleLogin(code: code, idToken: idToken)).get()
        let authTokenResponse = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
        
        return authTokenResponse
    }
    
    public func logout() {
        // logout 기능
    }
}
