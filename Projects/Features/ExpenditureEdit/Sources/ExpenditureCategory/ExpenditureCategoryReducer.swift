//
//  ExpenditureCategoryReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct ExpenditureCategoryReducer: Reducer {
    public struct State: Equatable {
        var categoryItems: IdentifiedArrayOf<ExpenditureCategoryItemReducer.State> = []
        var selectedCategory: Category?
        @BindingState var text: String = ""
        var isInvaildText: Bool = false

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
        case setFocusState(Bool)
        case setCategory(Category, String)
    }

    public var body: some ReducerOf<ExpenditureCategoryReducer> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .category(id, .tappedCategory):
                let selectedCategory = state.categoryItems[id: id]?.category
                Category.allCases.forEach { category in
                    state.categoryItems.updateOrAppend(.init(category: category, isSelected: category == selectedCategory))
                }
                state.selectedCategory = selectedCategory
                let cateforyStrings = Category.allCases.map { $0.text }
                if state.text.isEmpty || cateforyStrings.contains(state.text) {
                    state.text = selectedCategory?.text ?? ""
                }
                return .none
                
            case .binding(\.$text):
                state.isInvaildText = vaildText(state.text)
                return .none

            case .setCategory(let selectedCategory, let text):
                Category.allCases.forEach { category in
                    state.categoryItems.updateOrAppend(.init(category: category, isSelected: category == selectedCategory))
                }
                state.selectedCategory = selectedCategory
                state.text = text
                return .none

            default:
                return .none
            }
        }
        .forEach(\.categoryItems, action: /Action.category) {
            ExpenditureCategoryItemReducer()
        }
    }

    func vaildText(_ text: String) -> Bool {
        return text.count > 10
    }
}
