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
        do {
            let response = try await provider.request(.kakaoLogin(token: token)).get()
            let authTokenResponse = try JSONDecoder().decode(AuthTokenResponse.self, from: response.data)
            return authTokenResponse
        } catch {
            throw error
        }
    }
    
    public func loginWithApple() {
        // apple login
    }
    
    public func logout() {
        // logout 기능
    }
}


final class NetworkLogger: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        #if DEBUG
        print("\n---------- [REQUEST] ----------\n")
        print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
        print("Headers : \(target.headers ?? [:])")
        print("Task : \(target.task)")
        print("--------------------------------\n")
        #endif
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        #if DEBUG
        switch result {
        case let .success(response):
            guard let httpURLResponse = response.response else {
                break
            }
            print("\n---------- [RESPONSE] ----------\n")
            print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
            print("Headers : \(httpURLResponse.allHeaderFields)")
            print("Response JSON : \(try! response.mapJSON())")
            print("---------------------------------\n")
        case let .failure(error):
            print("\n---------- [ERROR RESPONSE] ----------\n")
            print("API Endpoint : \(target.baseURL.absoluteString + target.path)")
            print("Headers : \(target.headers ?? [:])")
            print("Task : \(target.task)")
            print("Error : \(error)")
            if let responseData = error.response?.data {
                let responseString = String(data: responseData, encoding: .utf8) ?? "Unable to decode response"
                print("Raw Response : \(responseString)")
            }
            print("--------------------------------\n")

        }
        #endif
    }

}
