//
//  ExpendpenditureInputReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import DesignSystem

public struct ExpenditureInputReducer: Reducer {
    public struct State: Equatable {
        @BindingState var text: String = ""
        var currency: Double = 0.05
        var currencyText: String = "= 0원"
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    public var body: some ReducerOf<ExpenditureInputReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.$text):
                if state.text.count < 10 {
                    let convertedCurrency = Int((Double(state.text) ?? 0.0) * state.currency)
                    let formattedText = convertedCurrency.formattedWithSeparator
                    state.currencyText = "= \(formattedText)원"
                } else {
                    state.currencyText = "나타낼 수 없습니다."
                }
                return .none
            default:
                return .none
            }
        }
    }
}

