//
//  TotalExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/24/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct TotalExpenditureListReducer: Reducer {
    public struct State: Equatable {
        var totalPrice: TotalPriceReducer.State
        var expenditureList = ExpenditureListReducer.State()

        init(expenditureType: ExpenditureTab, totalPriceType: TotalPriceTab) {
            self.totalPrice = .init(
                expenseType: expenditureType,
                isTappable: false
            )
        }
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
