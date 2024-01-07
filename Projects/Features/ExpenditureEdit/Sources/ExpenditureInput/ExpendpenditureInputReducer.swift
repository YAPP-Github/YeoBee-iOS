//
//  ExpendpenditureInputReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureInputReducer: Reducer {
    public struct State: Equatable {
        @BindingState var text: String = ""
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    public var body: some ReducerOf<ExpenditureInputReducer> {
        BindingReducer()

        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
