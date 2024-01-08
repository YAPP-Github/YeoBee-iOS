//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public enum ExpenditureTab: Equatable {
    case individual, shared
}

public struct ExpenditureReducer: Reducer {
    public struct State: Equatable {
        @BindingState var seletedExpenditureType: ExpenditureTab = .individual
        var expenditureEdit = ExpendpenditureEditReducer.State()

        public init(seletedExpenditureType: ExpenditureTab) {
            self.seletedExpenditureType = seletedExpenditureType
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<ExpenditureReducer.State>)
        case expenditureEdit(ExpendpenditureEditReducer.Action)
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
    }
}
