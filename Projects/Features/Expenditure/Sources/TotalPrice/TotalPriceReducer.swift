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
        var totalBudgetPrice: Int = 100000000000000
        var remainBudgetPrice: Int = 1000000000

        init(type: ExpenditureTab) {
            self.type = type
        }
    }

    public enum Action {
    }

    public var body: some ReducerOf<TotalPriceReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
