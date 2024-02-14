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
    case europe = "유럽"
    case asia = "아시아"
    case northAmerica = "북아메리카"
    case southAmerica = "남아메리카"
    case oceania = "오세아니아"
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
    var europe: [Country]
    var asia: [Country]
    var northAmerica: [Country]
    var southAmerica: [Country]
    var oceania: [Country]
    var africa: [Country]
}
