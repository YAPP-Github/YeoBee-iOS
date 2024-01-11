//
//  ExpenseService.swift
//  Network
//
//  Created by 태태's MacBook on 1/2/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya

enum ExpenseType: String {
    case shared = "SHARED"
    case individual = "INDIVIDUAL"
    case sharedBudgetIncome = "SHARED_BUDGET_INCOME"
    case sharedBudgetExpense = "SHARED_BUDGET_EXPENSE"
    case individualBudgetIncome = "INDIVIDUAL_BUDGET_INCOME"
    case individualBudgetExpense = "INDIVIDUAL_BUDGET_EXPENSE"
}

enum PaymentMethod: String {
    case cash = "CASH"
    case card = "CARD"
}

enum ExpenseService {
    case fetchList(tripId: String,
                   pageIndex: Int,
                   pageSize: Int,
                   type: ExpenseType? = nil,
                   date: Date? = nil,
                   paymentMethods: PaymentMethod? = nil,
                   unitId: Int? = nil)
    //    case fetchDetail
    //    case create
    //    case delete
}

extension ExpenseService: TargetType {
    var baseURL: URL { return URL(string: "https://api.yeobee.me")!}
    
    var path: String {
        switch self {
        case .fetchList:
            return "/v1/expense/list"
            //        case .fetchDetail:
            //            return "v1/expense"
            //        case .create:
            //            return "v1/expense"
            //        case .delete:
            //            return "v1/expense"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchList:
            return .get
            //        case .fetchDetail:
            //            return .get
            //        case .create:
            //            return .post
            //        case .delete:
            //            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case let .fetchList(tripId, pageIndex, pageSize, type, date, method, unitId):
            var params: [String: Any] = [
                "tripId": tripId,
                "pageIndex": pageIndex,
                "pageSize": pageSize
            ]
            if let type { params["type"] = type.rawValue }
            if let date { params["date"] = ISO8601DateFormatter().string(from: date) }
            if let method { params["method"] = method.rawValue }
            if let unitId { params["unitId"] = unitId }
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            //        case .fetchDetail:
            //
            //        case .create:
            //            <#code#>
            //        case .delete:
            //            <#code#>
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
