//
//  CurrencyUseCase.swift
//  UseCase
//
//  Created by Hoyoung Lee on 2/11/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

import Repository
import Entity
import ComposableArchitecture

public struct CurrencyUseCase {
    public var getTripCurrencies: @Sendable (_ tripId: Int) async throws -> [Currency]
    public var putTripCurrencies: @Sendable (
        _ tripId: Int,
        _ currencyCode: String,
        _ exchangeRate: ExchangeRate
    ) async throws -> Bool
    public var setCurrentlyCurrency: @Sendable (_ tripId: Int, _ currency: Currency) -> Void
    public var getCurrentlyCurrency: @Sendable (_ tripId: Int) -> Currency?
}

extension CurrencyUseCase: TestDependencyKey {
    public static let testValue: Self = unimplemented()
}

extension DependencyValues {
    public var currencyUseCase: CurrencyUseCase {
        get { self[CurrencyUseCase.self] }
        set { self[CurrencyUseCase.self] = newValue }
    }
}

extension CurrencyUseCase: DependencyKey {
    public static var liveValue: CurrencyUseCase {
        let currencyRepository = CurrencyRepository()
        return .init(getTripCurrencies: { tripId in
            return try await currencyRepository.getTripCurrency(tripId: tripId).currencyList
        }, putTripCurrencies: { tripId, currencyCode, exchangeRate in
            return try await currencyRepository.putTripCurrency(tripId, currencyCode, exchangeRate)
        }, setCurrentlyCurrency: { tripId, currency in
            UserDefaultsRepository.liveValue.setValue([tripId: currency], forKey: .selectedCurrency)
        }, getCurrentlyCurrency: { tripId in
            if let selectedCurrencies = UserDefaultsRepository.liveValue.value(forKey: .selectedCurrency) {
                return selectedCurrencies[tripId]
            }
            return nil
        })
    }
}
