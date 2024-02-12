//
//  CurrencyRepository.swift
//  Repository
//
//  Created by Hoyoung Lee on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import Moya
import YBNetwork
import Entity

public protocol CurrencyRepositoryInterface {
    func getTripCurrency(tripId: Int) async throws -> CurrencyResponse
}

final public class CurrencyRepository: CurrencyRepositoryInterface {

    public init() {}

    let provider = MoyaProvider<CurrencyService>(plugins: [NetworkLogger()])

    public func getTripCurrency(tripId: Int) async throws -> CurrencyResponse {
         let result = await provider.request(
            .getTripCurrencies(tripId: tripId)
        )
        switch result {
        case let .success(response):
            return try decode(data: response.data)
        case let .failure(error):
            throw error
        }
    }
}
