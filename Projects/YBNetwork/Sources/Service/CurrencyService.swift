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
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}

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
        return [
            "Content-type": "application/json",
            "Authorization": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyIiwiZXhwIjoxNzA4MTg2MTA5fQ.CXKRiLdVMTxwOAQGYC0m1KLeAEup9sn-z-v5ttAo_BI"
        ]
    }
}
