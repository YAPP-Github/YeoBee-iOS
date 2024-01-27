//
//  TotalExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/24/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct TotalExpenditureListReducer: Reducer {
    public struct State: Equatable {
        var totalPrice = TotalPriceReducer.State(type: .shared)
        var expenditureList = ExpenditureListReducer.State()
    }

    public enum Action {
        case totalPrice(TotalPriceReducer.Action)
        case expenditureList(ExpenditureListReducer.Action)
    }

    public var body: some ReducerOf<TotalExpenditureListReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }

        Scope(state: \.expenditureList, action: /Action.expenditureList) {
            ExpenditureListReducer()
        }

        Scope(state: \.totalPrice, action: /Action.totalPrice) {
            TotalPriceReducer()
        }
    }
}
