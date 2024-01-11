//
//  ExpendpenditureEditReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct ExpendpenditureEditReducer: Reducer {
    public struct State: Equatable {
        var expenditureInput = ExpenditureInputReducer.State()
        var expenditurePayment = ExpenditurePaymentReducer.State()
        var expenditureCategory = ExpenditureCategoryReducer.State()

        var isFocused: Bool = false
        var scrollItem: String = ""
    }

    public enum Action: Equatable {
        case expenditureInput(ExpenditureInputReducer.Action)
        case expenditurePayment(ExpenditurePaymentReducer.Action)
        case expenditureCategory(ExpenditureCategoryReducer.Action)
    }

    public var body: some ReducerOf<ExpendpenditureEditReducer> {
        Reduce { state, action in
            switch action {
            case let .expenditureCategory(.setFocusState(isFocused)):
                state.isFocused = isFocused
                state.scrollItem = "expenditureCategoryType"
                return .none
                default: return .none
            }
        }

        Scope(state: \.expenditureInput, action: /Action.expenditureInput) {
            ExpenditureInputReducer()
        }

        Scope(state: \.expenditurePayment, action: /Action.expenditurePayment) {
            ExpenditurePaymentReducer()
        }

        Scope(state: \.expenditureCategory, action: /Action.expenditureCategory) {
            ExpenditureCategoryReducer()
        }
    }
}
