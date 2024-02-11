//
//  UserInfoService.swift
//  YBNetwork
//
//  Created by 김태형 on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import Entity

public enum UserInfoService {
    case updateInfo(nickname: String, profileImageURL: String?)
    case updateState(state: String)
    case fetchInfo
}

extension UserInfoService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}
    
    public var path: String {
        switch self {
            case .updateInfo:
                return "/v1/users/me"
            case .updateState:
                return "/v1/user/me/state"
            case .fetchInfo:
                return "/v1/user/me"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .updateInfo:
                return .put
            case .updateState:
                return .patch
            case .fetchInfo:
                return .get
        }
    }
    
    public var task: Task {
        switch self {
            case let .updateInfo(nickname, profileImageURL):
                var params: [String: Any] = [
                    "nickname": nickname
                ]
                if let profileImageURL { params["profileImageUrl"] = profileImageURL}
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
                
            case let .updateState(state):
                var params: [String: Any] = [
                    "userState": state
                ]
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
                
            case .fetchInfo:
                return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        let token = KeychainManager.shared.load(key: KeychainManager.accessToken)
        
        return ["Authorization": "Bearer \(String(describing: token))"]
    }
}
