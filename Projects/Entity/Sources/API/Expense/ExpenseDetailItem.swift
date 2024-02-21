//
//  ExpenseDetailItem.swift
//  Entity
//
//  Created by Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct ExpenseDetailItem: Codable, Equatable {
    public var name: String
    public var amount: Double
    public var currency: String
    public var method: String
    public var koreanAmount: Int?
    public var payedAt: String
    public var category: ExpendCategory
    public var payerUserId: Int?
    public var payerId: Int?
    public var payerName: String?
    public var payerList: [Payer]

    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case currency = "currencyCode"
        case koreanAmount
        case payedAt
        case category = "expenseCategory"
        case payerUserId
        case payerName
        case payerList
        case method = "expenseMethod"
    }

    public init(
        name: String,
        amount: Double,
        currency: String,
        koreanAmount: Int? = nil,
        payedAt: String,
        category: ExpendCategory,
        payerUserId: Int?,
        payerId: Int?,
        payerName: String? = nil,
        payerList: [Payer],
        method: String
    ) {
        self.name = name
        self.amount = amount
        self.currency = currency
        self.koreanAmount = koreanAmount
        self.payedAt = payedAt
        self.payerUserId = payerUserId
        self.payerId = payerId
        self.category = category
        self.payerName = payerName
        self.payerList = payerList
        self.method = method
    }
}

public struct Payer: Codable, Equatable {
    public var id: Int?
    public var userId: Int?
    public var tripUserId: Int
    public var tripUserName: String?
    public var profileImageUrl: String?
    public var amount: Double

    public init(id: Int? = nil, userId: Int? = nil, tripUserId: Int, tripUserName: String? = nil, profileImageUrl: String? = nil, amount: Double) {
        self.id = id
        self.userId = userId
        self.tripUserId = tripUserId
        self.tripUserName = tripUserName
        self.profileImageUrl = profileImageUrl
        self.amount = amount
    }
}
