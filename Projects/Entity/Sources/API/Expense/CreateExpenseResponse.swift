//
//  CreateExpenseResponse.swift
//  Entity
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct CreateExpenseResponse: Codable {
    public var tripId: Int
    public var pageAt: Date
    public var type: ExpenseType
    public var amount: Double
    public var currencyCode: String
    public var expenseMethod: String
    public var expenseCategory: String
    public var name: String
    public var payerId: Int
    public var payerList: [PayerResponse]?
    public var imageList: [ImageRequest]?
}

public struct PayerResponse: Codable {
    public var id: Int
    public var tripUserId: Int
    public var amount: Int
}