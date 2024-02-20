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
        @BindingState var text: String = ""
        var selectedCurrency: Currency = .init(name: "원", code: "KRW", exchangeRate: .init(value: 1, standard: 1))
        var currencies: [Currency] = []
    }

    public enum Action: BindableAction, Equatable {
        case setCurrency(Currency)
        case binding(BindingAction<State>)
        case tappedCurrencyButton(Currency)
        case setInput(String, Currency?)
    }

    enum DebounceId: Hashable { case id }

    public var body: some ReducerOf<ExpenditureInputReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .setCurrency(currency):
                state.selectedCurrency = currency
                return .none

            case .setInput(let text, let currency):
                state.text = text
                state.selectedCurrency = currency ?? .init(name: "원", code: "KRW", exchangeRate: .init(value: 1, standard: 1))
                return .none

            case .binding(\.$text):
                return .none
            default:
                return .none
            }
        }
    }
}

