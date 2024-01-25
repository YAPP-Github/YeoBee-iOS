//
//  TripRequest.swift
//  Entity
//
//  Created by 박현준 on 1/25/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

// 여행 등록, 수정
public struct TripRequest: Encodable {
    public var title: String
    public var startDate: String
    public var endDate: String
    public var countryList: [CountryAndTripUserItemRequest]
    public var tripUserList: [CountryAndTripUserItemRequest]
    
    public init(
        title: String,
        startDate: String,
        endDate: String,
        countryList: [CountryAndTripUserItemRequest],
        tripUserList: [CountryAndTripUserItemRequest]
    ) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.countryList = countryList
        self.tripUserList = tripUserList
    }
}

public struct CountryAndTripUserItemRequest: Encodable, Equatable {
    var name: String
    
    public init(name: String) {
        self.name = name
    }
}
