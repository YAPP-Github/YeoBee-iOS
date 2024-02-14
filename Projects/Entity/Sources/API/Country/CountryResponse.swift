//
//  CountryResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 나라 선택
public struct CountryListResponse: Codable {
    public var countryList: [String: [CountryResponse]]
}

public struct CountryResponse: Codable, Hashable {
    public var name: String
    public var flagImageUrl: String?
    public var coverImageUrl: String?
    public var continent: String
}
