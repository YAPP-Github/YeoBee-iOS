//
//  TripCalculationService.swift
//  YBNetwork
//
//  Created by Hoyoung Lee on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

public enum TripCalculationService {
    case getBudget(tripId: Int)
}

extension TripCalculationService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}

    public var path: String {
        switch self {
        case let .getBudget(tripId):
            return "/v1/trips/\(tripId)/budget"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getBudget:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .getBudget:
            return .requestPlain
        }
    }

    public var headers: [String : String]? {
        return [
            "Content-type": "application/json",
            "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyIiwiZXhwIjoxNzA4MTg2MTA5fQ.CXKRiLdVMTxwOAQGYC0m1KLeAEup9sn-z-v5ttAo_BI"
        ]
    }
}
