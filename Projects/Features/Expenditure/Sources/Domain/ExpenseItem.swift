//
//  ExpenseItem.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 1/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct ExpenseItem: Equatable {
    var title: String
    var price: Int
    var currency: Currency
    var exchangedPrice: Int?
    var category: ExpendCategory
}

public struct Currency: Equatable {
    var prefix: String
    var exchangeRate: Double
}

extension Currency {
    static let krw: Currency = .init(prefix: "원", exchangeRate: 0)
    static let usd: Currency = .init(prefix: " USD", exchangeRate: 1315)
    static let jpy: Currency = .init(prefix: " JPY", exchangeRate: 907.49)
    static let eur: Currency = .init(prefix: " EUR", exchangeRate: 1440.32)
    static let cny: Currency = .init(prefix: " CNY", exchangeRate: 182.83)
}
