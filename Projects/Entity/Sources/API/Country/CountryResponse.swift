//
//  CountryResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 나라 선택
public struct CountryResponse: Codable {
    var name: String
    var flagImageUrl: String
    var coverImageUrl: String
    var continent: String
}
