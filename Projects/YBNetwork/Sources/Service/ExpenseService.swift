//
//  ExpenseService.swift
//  Network
//
//  Created by 태태's MacBook on 1/2/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

public enum ExpenseService {
    case fetchList(
        tripId: Int,
        pageIndex: Int,
        pageSize: Int,
        type: String? = nil,
        date: Date? = nil,
        paymentMethod: String? = nil,
        unitId: Int? = nil
    )
    case fetchDetail(Int)
    case create(Codable)
    case delete(Int)
    case update(Int, Codable)
}

extension ExpenseService: TargetType {
    public var baseURL: URL { return URL(string: YeoBeeAPI.shared.baseURL ?? "")!}

    public var path: String {
        switch self {
        case .fetchList:
            return "/v1/expenses"
        case let .fetchDetail(expenseId):
            return "/v1/expenses/\(expenseId)"
        case .create:
            return "/v1/expenses"
        case let .delete(expenseId):
            return "v1/expenses/\(expenseId)"
        case let .update(expenseId, _):
            return "v1/expenses/\(expenseId)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchList:
            return .get
        case .fetchDetail:
            return .get
        case .create:
            return .post
        case .delete:
            return .delete
        case .update:
            return .put
        }
    }

    public var task: Task {
        switch self {
        case let .fetchList(tripId, pageIndex, pageSize, type, date, method, unitId):
            var params: [String: Any] = [
                "tripId": tripId,
                "pageIndex": pageIndex,
                "pageSize": pageSize
            ]
            if let type { params["expenseType"] = type }
            if let date { params["payedAt"] = payedAtDateFormatter.string(from: date) }
            if let method { params["method"] = method }
            if let unitId { params["unitId"] = unitId }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .fetchDetail:
            return .requestPlain
        case let .create(data):
            return .requestJSONEncodable(data)
        case .delete:
            return .requestPlain
        case let .update(_, data):
            return .requestJSONEncodable(data)
        }
    }
    
    public var headers: [String: String]? {
        if let token = KeychainManager.shared.load(key: KeychainManager.accessToken) {
            return ["Authorization": "Bearer \(token)"]
        } else {
            return nil
        }
    }

    var payedAtDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }
}
