//
//  ExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct ExpenditureListReducer: Reducer {

    enum LoadStatus { case idle, process, done }

    public struct State: Equatable, Identifiable {
        public var id: Date { self.date }

        let tripItem: TripItem
        var type: ExpenditureTab
        var expenditureListItems: IdentifiedArrayOf<ExpenditureListItemReducer.State> = []
        var loadStatus: LoadStatus = .done
        var isEmpty: Bool { expenditureListItems.isEmpty && loadStatus == .done }

        var currentFilter: PaymentMethod?
        var pageIndex: Int = 0
        var isLastPage: Bool = false
        var date: Date

        init(type: ExpenditureTab, tripItem: TripItem, date: Date) {
            self.type = type
            self.tripItem = tripItem
            self.date = date
        }
    }

    public enum Action {
        case expenditureListItem(id: ExpenditureListItemReducer.State.ID, action: ExpenditureListItemReducer.Action)
        case setExpenditures([ExpenseItem], Bool)
        case getExpenditure(Bool)
        case appendExpenditures
        case setLastPage(Bool)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase

    public var body: some ReducerOf<ExpenditureListReducer> {
        Reduce { state, action in
            switch action {
            case let .setExpenditures(items, isReset):
                if isReset {
                    state.expenditureListItems.removeAll()
                }
                items.forEach { item in
                    state.expenditureListItems.updateOrAppend(.init(expendseItem: item))
                }
                return .none

            case .getExpenditure(let isReset):
                if isReset {
                    state.pageIndex = 0
                    state.isLastPage = false
                } else {
                    state.pageIndex += 1
                }
                return .run { [
                    pageIndex = state.pageIndex,
                    isReset,
                    tripId = state.tripItem.id,
                    expenseMethod = state.currentFilter,
                    expenseType = state.type,
                    tripDate = state.date
                ] send in
                    let (expenseItems, isLastPage) = try await expenseUseCase.getExpenseList(
                        tripId,
                        tripDate,
                        expenseType == .individual ? .individualAll : .sharedAll,
                        expenseMethod,
                        pageIndex
                    )
                    await send(.setExpenditures(expenseItems, isReset))
                    if isLastPage { await send(.setLastPage(isLastPage)) }
                } catch: { error, send in
                    print(error)
                    await send(.setLastPage(true))
                }

            case .appendExpenditures:
                if state.isLastPage == false {
                    return .send(.getExpenditure(false))
                }
                return .none

            case let .setLastPage(isLastPage):
                state.pageIndex = 0
                state.isLastPage = isLastPage
                return .none

            default:
                return .none
            }
        }
        .forEach(\.expenditureListItems, action: /Action.expenditureListItem) {
            ExpenditureListItemReducer()
        }
    }
}
