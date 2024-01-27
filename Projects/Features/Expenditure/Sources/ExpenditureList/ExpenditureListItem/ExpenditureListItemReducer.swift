//
//  ExpenditureListItemReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public struct ExpenditureListItemReducer: Reducer {
    public struct State: Equatable, Identifiable {
        public var id: UUID { UUID() }
        var expendseItem: ExpenseItem

        init(expendseItem: ExpenseItem) {
            self.expendseItem = expendseItem
        }
    }

    public enum Action {
        case tappedExpenditureItem(ExpenseItem)
    }

    public var body: some ReducerOf<ExpenditureListItemReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
    }
}
