//
//  TotalBudgetExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public enum TotalPriceTab: Equatable {
    case expense, budget
}

public struct TotalBudgetExpenditureListReducer: Reducer {

    let cooridinator: ExpenditureCoordinator

    init(cooridinator: ExpenditureCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {
        @BindingState var seletedTotalPriceTab: TotalPriceTab = .budget
        var totalBudget: TotalExpenditureListReducer.State
        var totalExpense: TotalExpenditureListReducer.State

        init(expenseType: ExpenditureTab) {
            self.totalExpense = .init(expenditureType: expenseType, totalPriceType: .budget)
            self.totalBudget = .init(expenditureType: expenseType, totalPriceType: .expense)
        }
    }

    public enum Action: BindableAction {
        case onAppear
        case binding(BindingAction<State>)
        case totalBudget(TotalExpenditureListReducer.Action)
        case totalExpense(TotalExpenditureListReducer.Action)
    }

    public var body: some ReducerOf<TotalBudgetExpenditureListReducer> {
        BindingReducer()
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }

        Scope(state: \.totalBudget, action: /Action.totalBudget) {
            TotalExpenditureListReducer()
        }

        Scope(state: \.totalExpense, action: /Action.totalExpense) {
            TotalExpenditureListReducer()
        }
    }
}
