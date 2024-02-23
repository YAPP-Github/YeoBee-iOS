//
//  Currency.swift
//  Entity
//
//  Created by Hoyoung Lee on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct Currency: Codable, Hashable {
    public var name: String
    public var code: String
    public var exchangeRate: ExchangeRate

    public init(name: String, code: String, exchangeRate: ExchangeRate) {
        self.name = name
        self.code = code
        self.exchangeRate = exchangeRate
    }
}

public struct ExchangeRate: Codable, Hashable {
    public var value: Double
    public var standard: Int

    public init(value: Double, standard: Int) {
        self.value = value
        self.standard = standard
    }
}

public struct ExchangeRateRqeust: Codable {
    public var value: Double
    public var standard: Int
    public var tripId: Int

    public init(value: Double, standard: Int, tripId: Int) {
        self.value = value
        self.standard = standard
        self.tripId = tripId
    }
}
