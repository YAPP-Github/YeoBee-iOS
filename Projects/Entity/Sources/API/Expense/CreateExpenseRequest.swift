//
//  CreateExpenseRequest.swift
//  Entity
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct CreateExpenseRequest: Codable {
    public var tripId: String
    public var pageAt: Date
    public var type: ExpenseType
    public var amount: Double
    public var currencyCode: String
    public var expenseMethod: String
    public var expenseCategory: String
    public var name: String
    public var payerId: Int
    public var payerList: [PayerRequest]?
    public var imageList: [ImageRequest]?
}

public struct PayerRequest: Codable {
    public var tripUserId: Int
    public var amount: Int
}
