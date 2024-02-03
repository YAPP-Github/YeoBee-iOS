//
//  FetchExpenseListRequest.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct FetchExpenseListRequest: Codable {
    public var tripId: Int
    public var pageIndex: Int
    public var pageSize: Int
    public var type: ExpenseType?
    public var date: Date?
    public var method: PaymentMethod?
    public var unitId: Int?

    public init(
        tripId: Int,
        pageIndex: Int,
        pageSize: Int,
        type: ExpenseType? = nil,
        date: Date? = nil,
        method: PaymentMethod? = nil,
        unitId: Int? = nil
    ) {
        self.tripId = tripId
        self.pageIndex = pageIndex
        self.pageSize = pageSize
        self.type = type
        self.date = date
        self.method = method
        self.unitId = unitId
    }
}
