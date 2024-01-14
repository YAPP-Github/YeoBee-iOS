//
//  ExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureListReducer: Reducer {

    enum LoadStatus { case idle, process, done }

    public struct State: Equatable {
        var expenditureListItems: IdentifiedArrayOf<ExpenditureListItemReducer.State> = []
        var loadStatus: LoadStatus = .done
        var isEmpty: Bool { expenditureListItems.isEmpty && loadStatus == .done }
    }

    public enum Action {
        case expenditureListItem(id: ExpenditureListItemReducer.State.ID, action: ExpenditureListItemReducer.Action)
        case setExpenditures()
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
