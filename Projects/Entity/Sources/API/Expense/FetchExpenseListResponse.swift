//
//  FetchExpenseListResponse.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// FetchExpenseListResponse 전체 모델
struct FetchExpenseListResponse: Codable {
    var content: [ExpenseItem]
    var pageable: Pageable
    var totalPages: Int
    var totalElements: Int
    var last: Bool
    var size: Int
    var number: Int
    var sort: SortType
    var numberOfElements: Int
    var first: Bool
    var empty: Bool
}
