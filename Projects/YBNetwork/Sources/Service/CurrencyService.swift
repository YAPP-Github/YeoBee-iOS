//
//  CurrencyService.swift
//  YBNetwork
//
//  Created by Hoyoung Lee on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Entity
import Moya

public enum CurrencyService {
    case getTripCurrencies(tripId: Int)
    case putTripCurrencies(tripId: Int, currencyCode: String, exchangeRate: ExchangeRate)
}

extension CurrencyService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")! }

    public var path: String {
        switch self {
        case .getTripCurrencies:
            return "/v1/currencies"
        case .putTripCurrencies(let tripId, let currencyCode, _):
            return "/v1/currencies/\(currencyCode)/rate"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getTripCurrencies:
            return .get
        case .putTripCurrencies:
            return .put
        }
    }

    public var task: Task {
        switch self {
        case let .getTripCurrencies(tripId):
            return .requestParameters(parameters: ["tripId": tripId], encoding: URLEncoding.queryString)
        case let .putTripCurrencies(tripId, currencyCode, exchangeRate):
            let params: [String: Any] = [
                "tripId": tripId,
                "currencyCode": currencyCode
            ]
            
            let exchangeRateResult: [String: Any] = [
                "value": exchangeRate.value,
                "standard": exchangeRate.standard
            ]
            
            return .requestCompositeParameters(
                bodyParameters: exchangeRateResult,
                bodyEncoding: URLEncoding.httpBody,
                urlParameters: params
            )
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
