//
//  CreateExpenseRequest.swift
//  Entity
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct CreateExpenseRequest: Codable {
    public var tripId: Int
    public var payedAt: String
    public var expenseType: String
    public var amount: Double
    public var currencyCode: String
    public var expenseMethod: String
    public var expenseCategory: String
    public var name: String
    public var payerId: Int
    public var payerList: [PayerRequest]
    public var imageList: [ImageRequest]

    public init(
        tripId: Int,
        payedAt: String,
        expenseType: String,
        amount: Double,
        currencyCode: String,
        expenseMethod: String,
        expenseCategory: String,
        name: String,
        payerId: Int,
        payerList: [PayerRequest] = [],
        imageList: [ImageRequest] = []
    ) {
        self.tripId = tripId
        self.payedAt = payedAt
        self.expenseType = expenseType
        self.amount = amount
        self.currencyCode = currencyCode
        self.expenseMethod = expenseMethod
        self.expenseCategory = expenseCategory
        self.name = name
        self.payerId = payerId
        self.payerList = payerList
        self.imageList = imageList
    }
}

public struct PayerRequest: Codable {
    public var tripUserId: Int
    public var amount: Int
}
