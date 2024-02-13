//
//  TripService.swift
//  YBNetwork
//
//  Created by 박현준 on 2/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import Entity

public enum TripService {
    case getTrip(_ tripId: Int)
    case putTrip(_ tripId: Int)
    case deleteTrip(_ tripId: Int)
    case postTrip
    case getPastTrip(_ pageIndex: Int, _ pageSize: Int)
    case getPresentTrip(_ pageIndex: Int, _ pageSize: Int)
    case getFutureTrip(_ pageIndex: Int, _ pageSize: Int)
    case checkDateOverlap
}

extension TripService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}

    public var path: String {
        switch self {
        case .getTrip(let tripId):
            return "/v1/trips/\(tripId)"
        case .putTrip(let tripId):
            return "/v1/trips/\(tripId)"
        case .deleteTrip(let tripId):
            return "/v1/trips/\(tripId)"
        case .postTrip:
            return "/v1/trips"
        case .getPastTrip:
            return "/v1/trips/me/past"
        case .getPresentTrip:
            return "/v1/trips/me/present"
        case .getFutureTrip:
            return "/v1/trips/me/future"
        case .checkDateOverlap:
            return "/v1/trips/me/date-overlap"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getTrip, .getPastTrip, .getPresentTrip, .getFutureTrip, .checkDateOverlap:
            return .get
        case .putTrip:
            return .put
        case .deleteTrip:
            return .delete
        case .postTrip:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .getPastTrip(let pageIndex, let pageSize),
                .getPresentTrip(let pageIndex, let pageSize),
                .getFutureTrip(let pageIndex, let pageSize):
            let params: [String: Any] = [
                "pageIndex": pageIndex,
                "pageSize": pageSize
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        default:
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
