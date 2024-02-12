//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import Combine
import ComposableArchitecture
import UseCase

public struct ExpenditureReducer: Reducer {

    let cooridinator: ExpenditureCoordinator

    init(cooridinator: ExpenditureCoordinator) {
        self.cooridinator = cooridinator
    }
    public struct State: Equatable {
        var type: ExpenditureTab
        var totalPrice: TotalPriceReducer.State
        var tripDate: TripDateReducer.State
        var expenditureList = ExpenditureListReducer.State()
        var tripId: Int
        var startDate: Date
        var endDate: Date
        var beforeDate: Date
        var isInitialShow: Bool = true

        init(type: ExpenditureTab, tripId: Int, startDate: Date, endDate: Date) {
            self.type = type
            self.tripDate = TripDateReducer.State(startDate: startDate, endDate: endDate)
            self.totalPrice = .init(
                type: type,
                isTappable: true
            )
            self.tripId = tripId
            self.startDate = startDate
            self.endDate = endDate
            self.beforeDate = Calendar.current.date(byAdding: .day, value: -1, to: startDate) ?? Date()
        }
    }

    public enum Action {
        case onAppear
        case getExpenseList(Date)
        case totalPrice(TotalPriceReducer.Action)
        case tripDate(TripDateReducer.Action)
        case expenditureList(ExpenditureListReducer.Action)
        case tappedAddButton
        case tappedFilterButton
        case getExpenditure(Date)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase

    public var body: some ReducerOf<ExpenditureReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let currentDate = Date()
                if state.isInitialShow {
                    state.isInitialShow = false
                    let selectDate: Date
                    if currentDate < state.startDate {
                        selectDate = state.beforeDate
                    } else if currentDate > state.endDate {
                        selectDate = state.startDate
                    } else {
                        selectDate = currentDate
                    }
                    return .run { send in
                        await send(.tripDate(.selectDate(selectDate)))
                        await send(.getExpenditure(selectDate))
                    }
                } else {
                    return .none
                }

            case let .getExpenseList(selectDate):
                return .run { send in
                    await send(.tripDate(.selectDate(selectDate)))
                    await send(.getExpenditure(selectDate))
                }

            case .tripDate(.tappedTripReadyButton):
                return .send(.getExpenditure(state.beforeDate))

            case let .tripDate(.tripDateItem(id: id, action: .tappedItem)):
                guard let tripDate = state.tripDate.tripDateItems[id: id]?.date else { return .none }
                return .send(.getExpenditure(tripDate))

            case let .getExpenditure(tripDate):
                return .run { send in
                    let expenseItems = try await expenseUseCase.getExpenseList(1, tripDate)
                    await send(.expenditureList(.setExpenditures(expenseItems)))
                }

            case .tappedAddButton:
                let selectedDate = state.tripDate.selectedDate ?? state.beforeDate
                cooridinator.expenditureEdit(tripId: state.tripId, editDate: selectedDate)
                return .none

            case .totalPrice(.tappedTotalPrice):
                cooridinator.totalExpenditureList()
                return .none

            case .tappedFilterButton:
                return .none

            case let .expenditureList(.expenditureListItem(id: _, action: .tappedExpenditureItem(expenseItem))):
                cooridinator.expenditureDetail(expenseItem: expenseItem)
                return .none

            default:
                return .none
            }
        }

        Scope(state: \.totalPrice, action: /Action.totalPrice) {
            TotalPriceReducer()
        }

        Scope(state: \.tripDate, action: /Action.tripDate) {
            TripDateReducer()
        }

        Scope(state: \.expenditureList, action: /Action.expenditureList) {
            ExpenditureListReducer()
        }
    }
}
