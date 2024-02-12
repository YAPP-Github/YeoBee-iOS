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
    public var koreanAmount: Int?
//    public var category: ExpendCategory
    public var payerUserId: Int
    public var payerName: String?
    public var payerList: [Payer]

    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case currency = "currencyCode"
        case koreanAmount
//        case category = "expenseCategoryName"
        case payerUserId
        case payerName
        case payerList
    }
}

public struct Payer: Codable, Equatable {
    public var id: Int
    public var userId: Int
    public var tripUserId: Int
    public var tripUserName: String?
    public var profileImageUrl: String
    public var amount: Double
}
