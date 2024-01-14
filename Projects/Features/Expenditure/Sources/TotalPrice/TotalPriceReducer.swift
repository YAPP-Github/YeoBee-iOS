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
        var type: ExpenditureTab
        var totalExpandPrice: Int = 1000
        var totalBudgetPrice: Int = 0
        var remainBudgetPrice: Int = 0

        init(type: ExpenditureTab) {
            self.type = type
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
                state.totalExpandPrice = totalExpandPrice
                state.totalBudgetPrice = totalBudgetPrice ?? state.totalBudgetPrice
                state.remainBudgetPrice = remainBudgetPrice ?? state.remainBudgetPrice
                return .none
            case .tappedTotalPrice:
                return .none
            case .tappedBubgetPrice:
                return .none
            }
        }
    }
}
