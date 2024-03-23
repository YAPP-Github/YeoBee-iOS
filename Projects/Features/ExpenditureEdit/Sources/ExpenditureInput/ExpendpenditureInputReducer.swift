//
//  ExpendpenditureInputReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import DesignSystem
import Entity

public struct ExpenditureInputReducer: Reducer {
    public struct State: Equatable {
        let tripId: Int
        @BindingState var text: String = ""
        var selectedCurrency: Currency = .init(name: "원", code: "KRW", exchangeRate: .init(value: 1, standard: 1))
        var currencies: [Currency] = []

        public init(tripId: Int) {
            self.tripId = tripId
        }
    }

    public enum Action: BindableAction, Equatable {
        case setCurrency(Currency)
        case setCurrencies([Currency])
        case binding(BindingAction<State>)
        case tappedCurrencyButton(Currency)
        case setInput(String, Currency?)
        case setText(String)
    }

    @Dependency(\.currencyUseCase) var currencyUseCase

    enum DebounceId: Hashable { case id }

    public var body: some ReducerOf<ExpenditureInputReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .setCurrency(currency):
                state.selectedCurrency = currency
                currencyUseCase.setCurrentlyCurrency(state.tripId, currency)
                return .none

            case let .setCurrencies(currencies):
                state.currencies = currencies
                if let currentlyCurrency = currencyUseCase.getCurrentlyCurrency(state.tripId) {
                    state.selectedCurrency = currentlyCurrency
                } else {
                    state.selectedCurrency = currencies.first ?? .init(name: "원", code: "KRW", exchangeRate: .init(value: 1, standard: 1))
                }
                return .none

            case .setInput(let text, let currency):
                state.text = text
                if let currentlyCurrency = currencyUseCase.getCurrentlyCurrency(state.tripId) {
                    state.selectedCurrency = currentlyCurrency
                } else {
                    state.selectedCurrency = currency ?? .init(name: "원", code: "KRW", exchangeRate: .init(value: 1, standard: 1))
                }
                return .none

            case let .setText(text):
                state.text =  text
                return .none

            case .binding(\.$text):
                return .none
            default:
                return .none
            }
        }
    }
}

