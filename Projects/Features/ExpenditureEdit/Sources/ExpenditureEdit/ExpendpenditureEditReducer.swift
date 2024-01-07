//
//  ExpendpenditureEditReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpendpenditureEditReducer: Reducer {
    public struct State: Equatable {
        var expenditureInput = ExpenditureInputReducer.State()
        var expenditurePayment = ExpenditurePaymentReducer.State()
        var expenditureCategory = ExpenditureCategoryReducer.State()
    }

    public enum Action: Equatable {
        case expenditureInput(ExpenditureInputReducer.Action)
        case expenditurePayment(ExpenditurePaymentReducer.Action)
        case expenditureCategory(ExpenditureCategoryReducer.Action)
    }

    public var body: some ReducerOf<ExpendpenditureEditReducer> {
        Reduce { _, action in
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

        Scope(state: \.expenditureCategory, action: /Action.expenditureCategory) {
            ExpenditureCategoryReducer()
        }
    }
}
