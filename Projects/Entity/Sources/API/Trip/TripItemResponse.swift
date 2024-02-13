//
//  TripItemResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct TripItem: Codable {
    var id: Int
    var title: String
    var startDate: String
    var endDate: String
    var countryList: [CountryItem]
    var tripUserList: [TripUserItem]
    var createdAt: String
}

public struct CountryItem: Codable {
    var name: String
    var flagImageUrl: String
    var coverImageUrl: String
}

public struct TripUserItem: Codable {
    var id: Int
    var userId: Int
    var name: String
    var profileImageUrl: String?
}
