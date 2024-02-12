//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public enum ExpenditureTab: Equatable {
    case individual, shared
}

public struct ExpenditureReducer: Reducer {

    let cooridinator: ExpenditureAddCoordinator

    init(cooridinator: ExpenditureAddCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {
        @BindingState var seletedExpenditureType: ExpenditureTab = .individual
        var expenditureEdit: ExpendpenditureEditReducer.State
        var expenditureBudgetEdit: ExpenditureBudgetEditReducer.State
        var tripId: Int

        public init(seletedExpenditureType: ExpenditureTab, tripId: Int, editDate: Date) {
            self.expenditureEdit = .init(tripId: tripId, editDate: editDate)
            self.expenditureBudgetEdit = .init(tripId: tripId, editDate: editDate)
            self.seletedExpenditureType = seletedExpenditureType
            self.tripId = tripId
        }
    }

    public enum Action: BindableAction, Equatable {
        case onAppear
        case binding(BindingAction<ExpenditureReducer.State>)
        case expenditureEdit(ExpendpenditureEditReducer.Action)
        case expenditureBudgetEdit(ExpenditureBudgetEditReducer.Action)
    }

    @Dependency(\.currencyUseCase) var currencyUseCase

    public var body: some ReducerOf<ExpenditureReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [tripId = state.tripId] send in
                    let currencies = try await currencyUseCase.getTripCurrencies(tripId)             
                }
            case .expenditureEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
            case .expenditureBudgetEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
            default:
                return .none
            }
        }

        Scope(state: \.expenditureEdit, action: /Action.expenditureEdit) {
            ExpendpenditureEditReducer()
        }

        Scope(state: \.expenditureBudgetEdit, action: /Action.expenditureBudgetEdit) {
            ExpenditureBudgetEditReducer()
        }
    }
}
