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
    public var pageNumber: Int
    public var pageSize: Int
    public var sort: SortType
    public var offset: Int
    public var paged: Bool
    public var unpaged: Bool
}
