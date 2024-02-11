//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

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
        var tripDate = TripDateReducer.State()
        var expenditureList = ExpenditureListReducer.State()

        init(type: ExpenditureTab) {
            self.type = type
            self.totalPrice = .init(
                type: type,
                isTappable: true
            )
        }
    }

    public enum Action {
        case totalPrice(TotalPriceReducer.Action)
        case tripDate(TripDateReducer.Action)
        case expenditureList(ExpenditureListReducer.Action)
        case tappedAddButton
        case tappedFilterButton
    }

    @Dependency(\.expenseUseCase) var expenseUseCase

    public var body: some ReducerOf<ExpenditureReducer> {
        Reduce { state, action in
            switch action {
            case .tripDate(.tappedTripReadyButton):
                return .send(.expenditureList(.setExpenditures([])))
            case let .tripDate(.tripDateItem(id: id, action: .tappedItem)):
                guard let tripDate = state.tripDate.tripDateItems[id: id]?.date else { return .none }
                return .run { send in
                    let expenseItems = try await expenseUseCase.getExpenseList(1, tripDate)
                    await send(.expenditureList(.setExpenditures(expenseItems)))
                }
            case .tappedAddButton:
                cooridinator.expenditureEdit()
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
