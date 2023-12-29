//
//  ExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureListReducer: Reducer {
    public struct State: Equatable {
        var expenditureListItems: IdentifiedArrayOf<ExpenditureListItemReducer.State> = [
            .init(), .init()
        ]
    }

    public enum Action {
        case expenditureListItem(id: ExpenditureListItemReducer.State.ID, action: ExpenditureListItemReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureListReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }
        .forEach(\.expenditureListItems, action: /Action.expenditureListItem) {
            ExpenditureListItemReducer()
        }
    }
}
