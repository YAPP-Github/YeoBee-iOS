//
//  ExpenditureCategoryItemReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

enum Category: CaseIterable {
    case transition, eating, stay, travel, activity, shopping, air, etc
}

public struct ExpenditureCategoryItemReducer: Reducer {
    public struct State: Equatable, Identifiable {
        public var id: String { return category.text }
        var category: Category
        var isSelected: Bool
        init(category: Category, isSelected: Bool = false) {
            self.category = category
            self.isSelected = isSelected
        }
    }

    public enum Action: Equatable {
        case tappedCategory
    }

    public var body: some ReducerOf<ExpenditureCategoryItemReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
