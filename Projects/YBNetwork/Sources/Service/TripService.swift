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
    case putTrip(
        _ tripId: Int,
        _ title: String,
        _ startDate: String,
        _ endDate: String,
        _ tripUserList: [ModifyTripUserItemRequest]
    )
    case deleteTrip(_ tripId: Int)
    case postTrip(
        _ title: String,
        _ startDate: String,
        _ endDate: String,
        _ countryList: [CountryItemRequest],
        _ tripUserList: [TripUserItemRequest]
    )
    case getPastTrip(_ pageIndex: Int, _ pageSize: Int)
    case getPresentTrip(_ pageIndex: Int, _ pageSize: Int)
    case getFutureTrip(_ pageIndex: Int, _ pageSize: Int)
    case checkDateOverlap(_ startDate: String, _ endDate: String)
}

extension TripService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}

    public var path: String {
        switch self {
        case .getTrip(let tripId):
            return "/v1/trips/\(tripId)"
        case .putTrip(let tripId, _, _, _, _):
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
        case .putTrip(_, let title, let startDate, let endDate, let tripUserList):
            let modifyTripRequest = ModifyTripRequest(
                title: title,
                startDate: startDate,
                endDate: endDate,
                modifyTripUserList: tripUserList
            )
            return .requestJSONEncodable(modifyTripRequest)
        case .checkDateOverlap(let startDate, let endDate):
            let params: [String: Any] = [
                "startDate": startDate,
                "endDate": endDate
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .postTrip(let title, let startDate, let endDate, let countryList, let tripUserList):
            let registTripRequest = RegistTripRequest(
                title: title,
                startDate: startDate,
                endDate: endDate,
                countryList: countryList,
                tripUserList: tripUserList
            )
            return .requestJSONEncodable(registTripRequest)
        default:
            return .requestPlain
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
