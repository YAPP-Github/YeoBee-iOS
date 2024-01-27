//
//  TripResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct TripResponse: Codable {
    var content: [TripItemResponse]
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
