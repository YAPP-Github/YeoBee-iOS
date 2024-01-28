//
//  ExpenseItem.swift
//  Entity
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct ExpenseItem: Codable, Equatable {
    public var expenseType: ExpenseType
    public var title: String
    public var price: Int
    public var currency: Currency
    public var exchangedPrice: Int?
    public var category: ExpendCategory

    public init(expenseType: ExpenseType, title: String, price: Int, currency: Currency, exchangedPrice: Int? = nil, category: ExpendCategory) {
        self.expenseType = expenseType
        self.title = title
        self.price = price
        self.currency = currency
        self.exchangedPrice = exchangedPrice
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

public enum ExpendCategory: Codable {
    case transition, eating, stay, travel, activity, shopping, air, etc
}


