//
//  TripItemResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct TripItemResponse: Codable {
    var id: Int
    var title: String
    var startDate: String
    var endDate: String
    var countryList: [CountryItemResponse]
    var tripUserList: [TripUserItemResponse]
    var createdAt: String
}

public struct CountryItemResponse: Codable {
    var name: String
    var flagImageUrl: String
    var coverImageUrl: String
}

public struct TripUserItemResponse: Codable {
    var id: Int
    var name: String
    var profileImageUrl: String?
}
