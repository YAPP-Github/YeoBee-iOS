//
//  TotalPriceReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct TotalPriceReducer: Reducer {
    public struct State: Equatable {
        var expenseType: ExpenditureTab
        var totalExpandPrice: Int = 0
        var totalBudgetPrice: Int = 0
        var remainBudgetPrice: Int = 0
        var totalExpense: Int = 0
        var isTappable: Bool

        init(expenseType: ExpenditureTab, isTappable: Bool) {
            self.expenseType = expenseType
            self.isTappable = isTappable
        }
    }

    public enum Action {
        case setTotalPrice(Int, Int?, Int?, Int)
        case tappedTotalPrice
        case tappedBubgetPrice
    }

    public var body: some ReducerOf<TotalPriceReducer> {
        Reduce { state, action in
            switch action {
            case let .setTotalPrice(totalExpandPrice, totalBudgetPrice, remainBudgetPrice, totalExpense):
                state.totalExpandPrice = state.expenseType == .individual ? totalExpandPrice : totalExpense
                state.totalBudgetPrice = totalBudgetPrice ?? 0
                state.remainBudgetPrice = remainBudgetPrice ?? 0
                return .none
            case .tappedTotalPrice:
                return .none
            case .tappedBubgetPrice:
                return .none
            }
        }
    }
}
