//
//  TotalPriceReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct TotalPriceReducer: Reducer {
    public struct State: Equatable {
        var expenseType: ExpenditureTab
        var totalPriceType: TotalPriceTab
        var totalExpandPrice: Int = 1000
        var totalBudgetPrice: Int = 0
        var remainBudgetPrice: Int = 0
        var isTappable: Bool

        init(expenseType: ExpenditureTab, totalPriceType: TotalPriceTab, isTappable: Bool) {
            self.expenseType = expenseType
            self.totalPriceType = totalPriceType
            self.isTappable = isTappable
        }
    }

    public enum Action {
        case setTotalPrice(Int, Int?, Int?)
        case tappedTotalPrice
        case tappedBubgetPrice
    }

    public var body: some ReducerOf<TotalPriceReducer> {
        Reduce { state, action in
            switch action {
            case let .setTotalPrice(totalExpandPrice, totalBudgetPrice, remainBudgetPrice):
                state.totalExpandPrice = abs(totalExpandPrice)
                state.totalBudgetPrice = abs(totalBudgetPrice ?? 0) 
                state.remainBudgetPrice = abs(remainBudgetPrice ?? 0)
                return .none
            case .tappedTotalPrice:
                return .none
            case .tappedBubgetPrice:
                return .none
            }
        }
    }
}
