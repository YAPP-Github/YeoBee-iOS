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
    case calculation(tripId: Int)
}

extension TripCalculationService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}

    public var path: String {
        switch self {
        case let .getBudget(tripId):
            return "/v1/trips/\(tripId)/budget"
        case let .calculation(tripId):
            return "/v1/trips/\(tripId)/calculation"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getBudget:
            return .get
        case .calculation:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .getBudget:
            return .requestPlain
        case .calculation:
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
