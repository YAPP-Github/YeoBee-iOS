//
//  ExpenditureCategoryReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureCategoryReducer: Reducer {
    public struct State: Equatable {
        var categoryItems: IdentifiedArrayOf<ExpenditureCategoryItemReducer.State> = []
        @BindingState var text: String = ""

        init() {
            Category.allCases.forEach {
                self.categoryItems.updateOrAppend(ExpenditureCategoryItemReducer.State(category: $0))
            }
        }
    }

    public enum Action: Equatable, BindableAction {
        case category(ExpenditureCategoryItemReducer.State.ID, ExpenditureCategoryItemReducer.Action)
        case setTextField(String)
        case binding(BindingAction<State>)
    }

    public var body: some ReducerOf<ExpenditureCategoryReducer> {
        Reduce { state, action in
            switch action {
            case let .category(id, .tappedCategory):
                state.text = state.categoryItems[id: id]?.category.text ?? ""
                return .none
            default:
                return .none
            }
        }
        .forEach(\.categoryItems, action: /Action.category) {
            ExpenditureCategoryItemReducer()
        }
    }
}
