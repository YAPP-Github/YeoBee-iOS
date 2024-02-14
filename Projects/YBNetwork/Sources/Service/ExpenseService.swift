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
    //    case delete
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
            //        case .delete:
            //            return "v1/expense"
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
            //        case .delete:
            //            return .delete
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
            if let type { params["type"] = type }
            if let date { params["payedAt"] = payedAtDateFormatter.string(from: date) }
            if let method { params["method"] = method }
            if let unitId { params["unitId"] = unitId }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .fetchDetail:
            return .requestPlain
        case let .create(data):
            return .requestJSONEncodable(data)
            //        case .delete:
            //            <#code#>
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-type": "application/json",
                "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyIiwiZXhwIjoxNzA4MTg2MTA5fQ.CXKRiLdVMTxwOAQGYC0m1KLeAEup9sn-z-v5ttAo_BI"]
    }

    var payedAtDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter
    }
}
