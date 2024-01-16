//
//  ExpenseItem.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 1/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct ExpenseItem: Equatable {
    var expenseType: ExpenseType
    var title: String
    var price: Int
    var currency: Currency
    var exchangedPrice: Int?
    var category: ExpendCategory
}

public struct Currency: Equatable {
    var suffix: String
    var exchangeRate: Double
}

public enum ExpenseType {
    case expense
    case income

    var symbol: String {
        switch self {
        case .expense: "-"
        case .income: "+"
        }
    }
}

extension Currency {
    static let krw: Currency = .init(suffix: "원", exchangeRate: 0)
    static let usd: Currency = .init(suffix: " USD", exchangeRate: 1315)
    static let jpy: Currency = .init(suffix: " JPY", exchangeRate: 907.49)
    static let eur: Currency = .init(suffix: " EUR", exchangeRate: 1440.32)
    static let cny: Currency = .init(suffix: " CNY", exchangeRate: 182.83)
}
