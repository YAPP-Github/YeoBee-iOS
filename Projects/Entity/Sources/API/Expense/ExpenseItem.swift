//
//  ExpenseItem.swift
//  Entity
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct ExpenseItem: Codable, Equatable {
    public var id: Int
    public var name: String
    public var amount: Double
    public var currency: String
    public var koreanAmount: Int?
    public var category: ExpendCategory

    public init(id: Int, name: String, amount: Double, currency: String, koreanAmount: Int? = nil, category: ExpendCategory) {
        self.id = id
        self.name = name
        self.amount = amount
        self.currency = currency
        self.koreanAmount = koreanAmount
        self.category = category
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case currency = "currencyCode"
        case koreanAmount
        case category = "expenseCategoryImage"
    }
}

public enum ExpendCategory: String, Codable, Equatable {
    case transport = "TRANSPORT"
    case food = "FOOD"
    case lodge = "LODGE"
    case travel = "TRAVEL"
    case activity = "ACTIVITY"
    case flight = "FLIGHT"
    case shopping = "SHOPPING"
    case etc = "ETC"
    case income = "INCOME"
}
