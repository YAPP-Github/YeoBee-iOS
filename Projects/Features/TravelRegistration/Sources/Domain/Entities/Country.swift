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
    case africa = "아프리카"
    
    func getCountries() -> [Country] {
        switch self {
        case .total:
            return []
        case .europe:
            return Self.europeCountries
        case .asia:
            return Self.asiaCountries
        case .northAmerica:
            return Self.northAmericaCountries
        case .southAmerica:
            return Self.southAmericaCountries
        case .africa:
            return Self.africaCountries
        }
    }
    
    private static let europeCountries: [Country] = [Country(name: "유럽국가1", imageURL: "이미지URL1"),
                                                     Country(name: "유럽국가2", imageURL: "이미지URL2"),
                                                     Country(name: "유럽국가3", imageURL: "이미지URL3"),
                                                     Country(name: "유럽국가4", imageURL: "이미지URL4"),
                                                     Country(name: "유럽국가5", imageURL: "이미지URL5")]
    
    private static let asiaCountries: [Country] = [Country(name: "아시아국가1", imageURL: "이미지URL1"),
                                                   Country(name: "아시아국가2", imageURL: "이미지URL2"),
                                                   Country(name: "아시아국가3", imageURL: "이미지URL3")]
    
    private static let northAmericaCountries: [Country] = [Country(name: "북아메리카국가1", imageURL: "이미지URL1"),
                                                           Country(name: "북아메리카국가2", imageURL: "이미지URL2"),
                                                           Country(name: "북아메리카국가3", imageURL: "이미지URL3")]
    
    private static let southAmericaCountries: [Country] = [Country(name: "남아메리카국가1", imageURL: "이미지URL1"),
                                                           Country(name: "남아메리카국가2", imageURL: "이미지URL2"),
                                                           Country(name: "남아메리카국가3", imageURL: "이미지URL3"),
                                                           Country(name: "남아메리카국가4", imageURL: "이미지URL4"),
                                                           Country(name: "남아메리카국가5", imageURL: "이미지URL5"),
                                                           Country(name: "남아메리카국가6", imageURL: "이미지URL6"),
                                                           Country(name: "남아메리카국가7", imageURL: "이미지URL7"),
                                                           Country(name: "남아메리카국가8", imageURL: "이미지URL8"),
                                                           Country(name: "남아메리카국가9", imageURL: "이미지URL9"),
                                                           Country(name: "남아메리카국가10", imageURL: "이미지URL10"),
                                                           Country(name: "남아메리카국가11", imageURL: "이미지URL11"),
                                                           Country(name: "남아메리카국가12", imageURL: "이미지URL12"),
                                                           Country(name: "남아메리카국가13", imageURL: "이미지URL13"),
                                                           Country(name: "남아메리카국가14", imageURL: "이미지URL14"),
                                                           Country(name: "남아메리카국가15", imageURL: "이미지URL15")]
    
    private static let africaCountries: [Country] = [Country(name: "아프리카국가1", imageURL: "이미지URL1"),
                                                     Country(name: "아프리카국가2", imageURL: "이미지URL2"),
                                                     Country(name: "아프리카국가3", imageURL: "이미지URL3")]
}

public struct Country: Hashable, Equatable {
    var name: String
    var imageURL: String
    
    public static func  == (lhs: Country, rhs: Country) -> Bool {
        lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

public struct DataCountry {
    let europe: [Country]
    let asia: [Country]
    let northAmerica: [Country]
    let southAmerica: [Country]
    let africa: [Country]
}
