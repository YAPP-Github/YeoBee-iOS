//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity
import DesignSystem

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
        let expenditureTab: ExpenditureTab
        let expenseDetail: ExpenseDetailItem?

        public init(
            expenditureTab: ExpenditureTab,
            seletedExpenditureType: ExpenditureType,
            expenseItem: ExpenseItem?,
            tripItem: TripItem,
            editDate: Date,
            expenseDetail: ExpenseDetailItem?
        ) {
            self.expenditureEdit = .init(
                expenseItem: expenseItem,
                tripItem: tripItem,
                editDate: editDate,
                expenditureTab: expenditureTab,
                expenseDetail: expenseDetail
            )
            self.expenditureBudgetEdit = .init(
                expenseItem: expenseItem,
                tripItem: tripItem,
                editDate: editDate,
                expenditureTab: expenditureTab,
                expenseDetail: expenseDetail
            )
            self.seletedExpenditureType = seletedExpenditureType
            self.tripItem = tripItem
            self.expenditureTab = expenditureTab
            self.expenseDetail = expenseDetail
        }
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<ExpenditureReducer.State>)
        case expenditureEdit(ExpendpenditureEditReducer.Action)
        case expenditureBudgetEdit(ExpenditureBudgetEditReducer.Action)
        case setCurrencies([Currency])
        case setCalculationData(ExpenseDetailItem, ExpenditureType)
    }

    @Dependency(\.currencyUseCase) var currencyUseCase

    public var body: some ReducerOf<ExpenditureReducer> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .expenditureEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
            case .expenditureBudgetEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
            case let .expenditureEdit(.expenditureInput(.tappedCurrencyButton(currency))):
                let currencies = state.expenditureEdit.currencies
                cooridinator.showCurrencyBottomSheet(
                    currenyList: currencies,
                    selectedCurrency: currency,
                    expenseType: state.expenditureTab == .individual ? .individual : .shared
                )
                return .none
            case let .expenditureBudgetEdit(.expenditureInput(.tappedCurrencyButton(currency))):
                let currencies = state.expenditureBudgetEdit.currencies
                cooridinator.showCurrencyBottomSheet(
                    currenyList: currencies,
                    selectedCurrency: currency,
                    expenseType: state.expenditureTab == .individual ? .individualBudget : .sharedBudgetIncome
                )
                return .none
            case .expenditureEdit(.tappedCalculationButton):
                let amountString = state.expenditureEdit.expenditureInput.text.replacingOccurrences(of: ",", with: "")
                if let amount = Double(amountString) {
                    let expenseText = state.expenditureEdit.expenditureCategory.text
                    let currencyCode = state.expenditureEdit.expenditureInput.selectedCurrency.code
                    let expenseDetail: ExpenseDetailItem = .init(
                        name: expenseText,
                        amount: amount,
                        currency: currencyCode,
                        payedAt: "",
                        category: .etc, 
                        payerUserId: nil,
                        payerList: [],
                        method: ""
                    )
                    cooridinator.pushCalculation(expenseType: .expense, tripItem: state.tripItem, expenseDetail: expenseDetail)
                } else {
                    let toast = Toast.text(icon: .warning, "금액을 입력해주세요.")
                    toast.show()
                }
                return .none

            case .expenditureBudgetEdit(.tappedCalculationButton):
                let amountString = state.expenditureBudgetEdit.expenditureInput.text.replacingOccurrences(of: ",", with: "")
                if let amount = Double(amountString) {
                    let expenseText = state.expenditureBudgetEdit.expenditureInput.text
                    let currencyCode = state.expenditureBudgetEdit.expenditureInput.selectedCurrency.code
                    let expenseDetail: ExpenseDetailItem = .init(
                        name: expenseText,
                        amount: amount,
                        currency: currencyCode,
                        payedAt: "",
                        category: .etc,
                        payerUserId: nil,
                        payerList: [],
                        method: ""
                    )
                    cooridinator.pushCalculation(expenseType: .budget, tripItem: state.tripItem, expenseDetail: expenseDetail)
                } else {
                    let toast = Toast.text(icon: .warning, "금액을 입력해주세요.")
                    toast.show()
                }
                return .none

            case .setCalculationData(let expenseDetailItem, let expenseType):
                switch expenseType {
                case .expense:
                    return .run { send in
                        await send(.expenditureEdit(.setExpenditureDetail(expenseDetailItem)))
                        await send(.expenditureEdit(.expenditureInput(.setText(expenseDetailItem.amount.formattedWithSeparator))))
                    }
                case .budget:
                    return .run { send in
                        await send(.expenditureEdit(.setExpenditureDetail(expenseDetailItem)))
                        await send(.expenditureEdit(.expenditureInput(.setText(expenseDetailItem.amount.formattedWithSeparator))))
                    }
                }

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
