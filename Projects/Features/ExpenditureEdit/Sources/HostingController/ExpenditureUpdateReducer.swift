//
//  ExpenditureEditReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct ExpenditureUpdateReducer: Reducer {

    let cooridinator: ExpenditureEditCoordinator

    init(cooridinator: ExpenditureEditCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {

        enum ExpenditureEditRoute: Equatable {
            case expenditureEdit(ExpendpenditureEditReducer.State)
            case expenditureBudgetEdit(ExpenditureBudgetEditReducer.State)
        }
        var expenditureEditRoute: ExpenditureEditRoute
        var tripItem: TripItem

        public init(seletedExpenditureType: ExpenseType, tripItem: TripItem, expenseDetail: ExpenseDetailItem) {
            switch seletedExpenditureType {
            case .individual, .shared:
                self.expenditureEditRoute = .expenditureEdit(.init(tripItem: tripItem, editDate: Date(), expenditureTab: .individual))
            case .individualBudget, .sharedBudgetIncome:
                self.expenditureEditRoute = .expenditureBudgetEdit(.init(tripId: tripItem.id, editDate: Date(), expenditureTab: .individual))
            }
            self.tripItem = tripItem
        }
    }

    public enum Action: BindableAction, Equatable {
        case onAppear
        case binding(BindingAction<ExpenditureReducer.State>)
        case expenditureEdit(ExpendpenditureEditReducer.Action)
        case expenditureBudgetEdit(ExpenditureBudgetEditReducer.Action)
    }

    @Dependency(\.currencyUseCase) var currencyUseCase

    public var body: some ReducerOf<ExpenditureUpdateReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [tripId = state.tripItem.id] send in
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

        Scope(state: \.expenditureEditRoute, action: /.self) {
            Scope(state: /State.ExpenditureEditRoute.expenditureEdit, action: /Action.expenditureEdit) {
                ExpendpenditureEditReducer()
            }
        }

        Scope(state: \.expenditureEditRoute, action: /.self) {
            Scope(state: /State.ExpenditureEditRoute.expenditureBudgetEdit, action: /Action.expenditureBudgetEdit) {
                ExpenditureBudgetEditReducer()
            }
        }
    }
}

