//
//  LoginService.swift
//  YBNetwork
//
//  Created by 김태형 on 2/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

public enum LoginService {
    case kakaoLogin(token: String)
    case appleLogin(code: String, idToken: String)
    case revoke
}

extension LoginService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}
    
    public var path: String {
        switch self {
            case .kakaoLogin:
                return "/v1/auth/login/kakao"
            case .appleLogin:
                return "/v1/auth/login/apple"
            case .revoke:
                return "/v1/auth/revoke"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .kakaoLogin, .appleLogin:
                return .post
            case .revoke:
                return .delete
        }
    }
    
    public var task: Task {
        switch self {
            case .kakaoLogin(let token):
                return .requestParameters(parameters: ["oauthToken": token], encoding: JSONEncoding.default)
            case .appleLogin(let code, let idToken):
                return .requestParameters(parameters: ["code": code, "idToken": idToken], encoding: JSONEncoding.default)
            case .revoke:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        let token = KeychainManager.shared.load(key: KeychainManager.accessToken)
        switch self {
            case .revoke:
                return ["Content-type": "application/json", "Authorization": "Bearer \(token)"]
            default:
                return ["Content-type": "application/json"]
        }
    }
    
}
