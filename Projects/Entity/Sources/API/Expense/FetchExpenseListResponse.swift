//
//  FetchExpenseListResponse.swift
//  Entity
//
//  Created by 태태's MacBook on 1/5/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// FetchExpenseListResponse 전체 모델
public struct FetchExpenseListResponse: Codable {
    public var content: [ExpenseItem]
    public var pageable: Pageable
    public var totalPages: Int
    public var totalElements: Int
    public var last: Bool
    public var size: Int
    public var number: Int
    public var sort: SortType
    public var numberOfElements: Int
    public var first: Bool
    public var empty: Bool

    public init(
        content: [ExpenseItem],
        pageable: Pageable,
        totalPages: Int,
        totalElements: Int,
        last: Bool,
        size: Int,
        number: Int,
        sort: SortType,
        numberOfElements: Int,
        first: Bool,
        empty: Bool
    ) {
        self.content = content
        self.pageable = pageable
        self.totalPages = totalPages
        self.totalElements = totalElements
        self.last = last
        self.size = size
        self.number = number
        self.sort = sort
        self.numberOfElements = numberOfElements
        self.first = first
        self.empty = empty
    }
}
