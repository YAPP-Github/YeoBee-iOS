//
//  Currency.swift
//  Entity
//
//  Created by Hoyoung Lee on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct Currency: Codable, Equatable {
    public var name: String
    public var code: String
    public var exchangeRate: ExchangeRate

    public init(name: String, code: String, exchangeRate: ExchangeRate) {
        self.name = name
        self.code = code
        self.exchangeRate = exchangeRate
    }
}

public struct ExchangeRate: Codable, Equatable {
    public var value: Double

    public init(value: Double) {
        self.value = value
    }
}
