//
//  Country.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation

public enum CountryType: String, CaseIterable {
    case total = "전체"
    case asia = "아시아"
    case europe = "유럽"
    case oceania = "오세아니아"
    case america = "아메리카"
    case africa = "아프리카"
}

public struct Country: Hashable {
    var name: String
    var imageURL: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

public struct DataCountry {
    var asia: [Country]
    var europe: [Country]
    var oceania: [Country]
    var america: [Country]
    var africa: [Country]
}
