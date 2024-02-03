//
//  SortType.swift
//  Entity
//
//  Created by 태태's MacBook on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

//정렬 기준에 대한 모델
public struct SortType: Codable {
    var empty: Bool
    var unsorted: Bool
    var sorted: Bool
}
