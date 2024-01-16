//
//  ExpenditureBudgetContentReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct ExpenditureBudgetContentReducer: Reducer {
    public struct State: Equatable {
        @BindingState var text: String = ""
        var isInvaildText: Bool = false

        init() {
        }
    }

    public enum Action: Equatable, BindableAction {
        case setTextField(String)
        case binding(BindingAction<State>)
        case setFocusState(Bool)
    }

    public var body: some ReducerOf<ExpenditureBudgetContentReducer> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$text):
                state.isInvaildText = vaildText(state.text)
                return .none

            default:
                return .none
            }
        }
    }

    func vaildText(_ text: String) -> Bool {
        return text.count > 10
    }
}
