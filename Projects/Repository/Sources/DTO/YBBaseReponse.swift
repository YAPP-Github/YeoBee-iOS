//
//  YBBaseReponse.swift
//  Repository
//
//  Created by Hoyoung Lee on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct YBBaseReponse<T: Codable>: Codable {
    public var content: T
    public var pageable: PageableResponse
    public var totalPages: Int
    public var last: Bool
}

public struct PageableResponse: Codable {
    public var pageNumber: Int
    public var pageSize: Int
}
