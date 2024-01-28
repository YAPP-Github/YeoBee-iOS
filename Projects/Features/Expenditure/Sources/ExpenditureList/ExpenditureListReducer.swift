//
//  ExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture
import Entity

public struct ExpenditureListReducer: Reducer {

    enum LoadStatus { case idle, process, done }

    public struct State: Equatable {
        var expenditureListItems: IdentifiedArrayOf<ExpenditureListItemReducer.State> = []
        var loadStatus: LoadStatus = .done
        var isEmpty: Bool { expenditureListItems.isEmpty && loadStatus == .done }
    }

    public enum Action {
        case expenditureListItem(id: ExpenditureListItemReducer.State.ID, action: ExpenditureListItemReducer.Action)
        case setExpenditures([ExpenseItem])
    }

    public var body: some ReducerOf<ExpenditureListReducer> {
        Reduce { state, action in
            switch action {
            case let .setExpenditures(items):
                state.expenditureListItems.removeAll()
                items.forEach { item in
                    state.expenditureListItems.updateOrAppend(.init(expendseItem: item))
                }
                return .none
                default: return .none
            }
        }
        .forEach(\.expenditureListItems, action: /Action.expenditureListItem) {
            ExpenditureListItemReducer()
        }
    }
}
