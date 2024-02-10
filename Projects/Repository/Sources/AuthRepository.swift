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

public protocol AuthRepositoryInterface {
    func loginWithKakao(token: String) async throws -> AuthTokenResponse
    func loginWithApple()
    func logout()
}

final public class AuthRepository: AuthRepositoryInterface {
    
    public init() {}
    
    let provider = MoyaProvider<AuthService>(plugins: [NetworkLogger()])
    
    public func loginWithKakao(token: String) async throws -> AuthTokenResponse {
        let response = try await provider.request(.kakaoLogin(token: token)).get()
        let authTokenResponse = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
        return authTokenResponse
        
    }
    
    public func loginWithApple() {
        // apple login
    }
    
    public func logout() {
        // logout 기능
    }
}
