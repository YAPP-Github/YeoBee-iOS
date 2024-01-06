//
//  FetchExpenseListRequest.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

struct FetchExpenseListRequest: Codable {
    var tripId: Int
    var pageIndex: Int
    var pageSize: Int
    var type: ExpenseType?
    var date: Date?
    var method: PaymentMethod?
    var unitId: Int?
}
