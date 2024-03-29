//
//  RegistTripRequest.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 여행 등록
public struct RegistTripRequest: Encodable {
    public var title: String
    public var startDate: String
    public var endDate: String
    public var countryList: [CountryItemRequest]
    public var tripUserList: [TripUserItemRequest]
    
    public init(
        title: String,
        startDate: String,
        endDate: String,
        countryList: [CountryItemRequest],
        tripUserList: [TripUserItemRequest]
    ) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.countryList = countryList
        self.tripUserList = tripUserList
    }
}

public struct CountryItemRequest: Encodable {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct TripUserItemRequest: Encodable {
    public var name: String
    public var profileImageUrl: String
    
    public init(name: String, profileImageUrl: String) {
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
}
