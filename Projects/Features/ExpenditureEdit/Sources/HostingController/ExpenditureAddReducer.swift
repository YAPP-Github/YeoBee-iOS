//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public enum ExpenditureTab: Equatable {
    case individual, shared
}

public struct ExpenditureReducer: Reducer {

    public struct State: Equatable {
        @BindingState var seletedExpenditureType: ExpenditureTab = .individual
        var expenditureEdit = ExpendpenditureEditReducer.State()
        var expenditureBudgetEdit = ExpenditureBudgetEditReducer.State()

        public init(seletedExpenditureType: ExpenditureTab) {
            self.seletedExpenditureType = seletedExpenditureType
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<ExpenditureReducer.State>)
        case expenditureEdit(ExpendpenditureEditReducer.Action)
        case expenditureBudgetEdit(ExpenditureBudgetEditReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureReducer> {
        BindingReducer()

        Reduce { _, action in
            switch action {
                default: return .none
            }
        }

        Scope(state: \.expenditureEdit, action: /Action.expenditureEdit) {
            ExpendpenditureEditReducer()
        }

        Scope(state: \.expenditureBudgetEdit, action: /Action.expenditureBudgetEdit) {
            ExpenditureBudgetEditReducer()
        }
    }
}
