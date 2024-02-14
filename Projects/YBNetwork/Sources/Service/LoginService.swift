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
}

extension LoginService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}
    
    public var path: String {
        switch self {
            case .kakaoLogin:
                return "/v1/auth/login/kakao"
            case .appleLogin:
                return "/v1/auth/login/apple"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .kakaoLogin, .appleLogin:
                return .post
        }
    }
    
    public var task: Task {
        switch self {
            case .kakaoLogin(let token):
                return .requestParameters(parameters: ["oauthToken": token], encoding: JSONEncoding.default)
            case .appleLogin(let code, let idToken):
                return .requestParameters(parameters: ["code": code, "idToken": idToken], encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
