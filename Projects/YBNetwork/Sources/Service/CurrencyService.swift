//
//  CurrencyService.swift
//  YBNetwork
//
//  Created by Hoyoung Lee on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

public enum CurrencyService {
    case getTripCurrencies(tripId: Int)
}

extension CurrencyService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")! }

    public var path: String {
        switch self {
        case .getTripCurrencies:
            return "/v1/currencies"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getTripCurrencies:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .getTripCurrencies(tripId):
            return .requestParameters(parameters: ["tripId": tripId], encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String : String]? {
        if let token = KeychainManager.shared.load(key: KeychainManager.accessToken) {
            return ["Authorization": "Bearer \(token)"]
        } else {
            return nil
        }
    }
}
