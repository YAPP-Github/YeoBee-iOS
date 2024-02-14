//
//  TripResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct TripResponse: Codable {
    public var content: [TripItem]
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
}
