//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public enum ExpenditureType: Equatable {
    case expense, budget
}

public struct ExpenditureReducer: Reducer {

    let cooridinator: ExpenditureAddCoordinator

    init(cooridinator: ExpenditureAddCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {
        @BindingState var seletedExpenditureType: ExpenditureType = .expense
        var expenditureEdit: ExpendpenditureEditReducer.State
        var expenditureBudgetEdit: ExpenditureBudgetEditReducer.State
        var tripItem: TripItem
        var currencies: [Currency] = []
        let expenditureTab: ExpenditureTab

        public init(
            expenditureTab: ExpenditureTab,
            seletedExpenditureType: ExpenditureType,
            tripItem: TripItem,
            editDate: Date
        ) {
            self.expenditureEdit = .init(tripItem: tripItem, editDate: editDate, expenditureTab: expenditureTab)
            self.expenditureBudgetEdit = .init(tripId: tripItem.id, editDate: editDate, expenditureTab: expenditureTab)
            self.seletedExpenditureType = seletedExpenditureType
            self.tripItem = tripItem
            self.expenditureTab = expenditureTab
        }
    }

    public enum Action: BindableAction, Equatable {
        case onAppear
        case binding(BindingAction<ExpenditureReducer.State>)
        case expenditureEdit(ExpendpenditureEditReducer.Action)
        case expenditureBudgetEdit(ExpenditureBudgetEditReducer.Action)
        case setCurrencies([Currency])
    }

    @Dependency(\.currencyUseCase) var currencyUseCase

    public var body: some ReducerOf<ExpenditureReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [tripId = state.tripItem.id] send in
                    let currencies = try await currencyUseCase.getTripCurrencies(tripId)
                    await send(.setCurrencies(currencies))
                } catch: { error, send in
                    print(error)
                }
            case let .setCurrencies(currencyList):
                state.currencies = currencyList
                return .none
            case .expenditureEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
            case .expenditureBudgetEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
            case let .expenditureEdit(.expenditureInput(.tappedCurrencyButton(currency))):
                cooridinator.showCurrencyBottomSheet(
                    currenyList: state.currencies,
                    selectedCurrency: currency,
                    expenseType: .individual
                )
                return .none
            case let .expenditureBudgetEdit(.expenditureInput(.tappedCurrencyButton(currency))):
                cooridinator.showCurrencyBottomSheet(
                    currenyList: state.currencies,
                    selectedCurrency: currency,
                    expenseType: .individualBudget
                )
                return .none
            case .expenditureEdit(.tappedCalculationButton):
                let amountString = state.expenditureEdit.expenditureInput.text.replacingOccurrences(of: ",", with: "")
                if let amount = Double(amountString) {
                    let expenseText = state.expenditureEdit.expenditureCategory.text
                    let currencyCode = state.expenditureEdit.expenditureInput.selectedCurrency.code
                    let expenseDetail: ExpenseDetailItem = .init(name: expenseText, amount: amount, currency: currencyCode, payerUserId: nil, payerList: [])
                    cooridinator.pushCalculation(tripItem: state.tripItem, expenseDetail: expenseDetail)
                } else {
                    // 금액을 입력하지 않았습니다
                }
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
