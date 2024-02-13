//
//  TokenService.swift
//  YBNetwork
//
//  Created by 김태형 on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

public enum TokenService {
    case refresh(token: String)
}

extension TokenService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}

    public var path: String {
        switch self {
        case .refresh:
            return "/v1/auth/refresh"
        }
    }
    public var method: Moya.Method {
        switch self {
        case .refresh:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .refresh:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
