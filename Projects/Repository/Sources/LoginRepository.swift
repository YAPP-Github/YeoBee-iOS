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
    func revoke() async throws -> Int
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
    
    public func revoke() async throws -> Int {
        let response = try await provider.request(.revoke)
        switch response {
            case .success(let response):
                return response.statusCode
            case .failure(let error):
                throw error
        }
    }
}
