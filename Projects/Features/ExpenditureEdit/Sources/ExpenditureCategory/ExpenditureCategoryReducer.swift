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
        
        init() {
            Category.allCases.forEach {
                self.categoryItems.updateOrAppend(ExpenditureCategoryItemReducer.State(category: $0))
            }
        }
    }

    public enum Action: Equatable {
        case category(ExpenditureCategoryItemReducer.State.ID, ExpenditureCategoryItemReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureCategoryReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
        .forEach(\.categoryItems, action: /Action.category) {
            ExpenditureCategoryItemReducer()
        }
    }
}
