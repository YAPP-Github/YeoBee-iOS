//
//  CountryService.swift
//  YBNetwork
//
//  Created by 박현준 on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import Entity

public enum CountryService {
    case getCountries
}

extension CountryService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}
    
    public var path: String {
        switch self {
            case .getCountries:
                return "/v1/countries"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .getCountries:
                return .get
        }
    }
    
    public var task: Task {
        switch self {
            case .getCountries:
                return .requestPlain
        }
    }
    
    public var headers: [String: String]? {
        if let token = KeychainManager.shared.load(key: KeychainManager.accessToken) {
            return ["Authorization": "Bearer \(token)"]
        } else {
            return nil
        }
    }
}
