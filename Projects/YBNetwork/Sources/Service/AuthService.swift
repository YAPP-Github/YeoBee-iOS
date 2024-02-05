//
//  AuthService.swift
//  Network
//
//  Created by 태태's MacBook on 1/2/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

enum AuthService {
    case kakaoLogin(token: String)
}

extension AuthService: TargetType {
    var baseURL: URL { return URL(string: "BaseURL")!}

    var path: String {
        switch self {
        case .kakaoLogin:
            return "/v1/auth/kakao"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .kakaoLogin(let token):
            return .requestParameters(parameters: ["oauthToken": token], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
