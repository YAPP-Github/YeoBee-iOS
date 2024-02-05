//
//  Pageable.swift
//  Entity
//
//  Created by 태태's MacBook on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 페이지 정보
public struct Pageable: Codable {
    var pageNumber: Int
    var pageSize: Int
    var sort: SortType
    var offset: Int
    var paged: Bool
    var unpaged: Bool
}
