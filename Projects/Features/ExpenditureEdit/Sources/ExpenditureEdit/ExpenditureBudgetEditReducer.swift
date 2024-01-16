//
//  ExpenditureBudgetEditReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureBudgetEditReducer: Reducer {
    public struct State: Equatable {
        var expenditureInput = ExpenditureInputReducer.State()
        var expenditurePayment = ExpenditurePaymentReducer.State()
        var expenditureContent = ExpenditureBudgetContentReducer.State()

        var isFocused: Bool = false
        var scrollItem: String = ""
    }

    public enum Action: Equatable {
        case expenditureInput(ExpenditureInputReducer.Action)
        case expenditurePayment(ExpenditurePaymentReducer.Action)
        case expenditureContent(ExpenditureBudgetContentReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureBudgetEditReducer> {
        Reduce { state, action in
            switch action {
                default: return .none
            }
        }

        Scope(state: \.expenditureInput, action: /Action.expenditureInput) {
            ExpenditureInputReducer()
        }

        Scope(state: \.expenditurePayment, action: /Action.expenditurePayment) {
            ExpenditurePaymentReducer()
        }

        Scope(state: \.expenditureContent, action: /Action.expenditureContent) {
            ExpenditureBudgetContentReducer()
        }
    }
}


