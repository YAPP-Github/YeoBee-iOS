//
//  TripItemResponse.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct TripItem: Codable, Hashable {
    public var id: Int
    public var title: String
    public var startDate: String
    public var endDate: String
    public var countryList: [CountryItem]
    public var tripUserList: [TripUserItem]
    public var createdAt: String
}

public struct CountryItem: Codable, Hashable {
    public var name: String
    public var flagImageUrl: String
    public var coverImageUrl: String?
}

public struct TripUserItem: Codable, Hashable, Identifiable {
    public var id: Int
    public var userId: Int?
    public var name: String?
    public var profileImageUrl: String?

    public init(id: Int, userId: Int? = nil, name: String? = nil, profileImageUrl: String? = nil) {
        self.id = id
        self.userId = userId
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
}
