//
//  ExpenseItem.swift
//  Entity
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct ExpenseItem: Codable, Equatable {
    public var name: String
    public var amount: Int
    public var currency: String
    public var koreanAmount: Int?
    public var category: ExpendCategory

    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case currency = "currencyCode"
        case koreanAmount
        case category = "expenseCategoryImage"
    }

    public init(
        name: String,
        amount: Int,
        currency: String,
        koreanAmount: Int? = nil,
        category: ExpendCategory
    ) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.koreanAmount = koreanAmount
        self.category = category
    }
}

public struct Currency: Equatable, Codable {
    public var suffix: String
    public var exchangeRate: Double
}

public extension Currency {
    static let krw: Currency = .init(suffix: "원", exchangeRate: 0)
    static let usd: Currency = .init(suffix: " USD", exchangeRate: 1315)
    static let jpy: Currency = .init(suffix: " JPY", exchangeRate: 907.49)
    static let eur: Currency = .init(suffix: " EUR", exchangeRate: 1440.32)
    static let cny: Currency = .init(suffix: " CNY", exchangeRate: 182.83)
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
