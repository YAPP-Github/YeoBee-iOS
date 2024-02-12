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
        var selectedCurrency: Currency = .init(name: "원", code: "KRW", exchangeRate: .init(value: 1.00))
        var currencies: [Currency] = []
    }

    public enum Action: BindableAction, Equatable {
        case setCurrencies([Currency])
        case binding(BindingAction<State>)
    }

    enum DebounceId: Hashable { case id }

    public var body: some ReducerOf<ExpenditureInputReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .setCurrencies(currencies):
                state.currencies = currencies
                state.selectedCurrency = currencies.first ?? .init(name: "원", code: "KRW", exchangeRate: .init(value: 1.00))
                return .none

            case .binding(\.$text):
                return .none
            default:
                return .none
            }
        }
    }
}

