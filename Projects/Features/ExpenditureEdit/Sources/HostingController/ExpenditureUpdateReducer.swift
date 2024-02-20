//
//  ExpenditureEditReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity
import DesignSystem

public struct ExpenditureUpdateReducer: Reducer {

    let cooridinator: ExpenditureEditCoordinator

    init(cooridinator: ExpenditureEditCoordinator) {
        self.cooridinator = cooridinator
    }

    public enum State: Equatable {
        case expenditureEdit(ExpendpenditureEditReducer.State)
        case expenditureBudgetEdit(ExpenditureBudgetEditReducer.State)

        public init(expenditureTab: ExpenditureTab, tripItem: TripItem, expenseDetail: ExpenseDetailItem) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let editDate = dateFormatter.date(from: expenseDetail.payedAt) ?? Date()
            if expenseDetail.category == .income {
                self = .expenditureBudgetEdit(.init(
                    tripItem: tripItem,
                    editDate: editDate,
                    expenditureTab: expenditureTab,
                    isAdd: true,
                    expenseDetail: expenseDetail
                ))
            } else {
                self = .expenditureEdit(.init(
                    tripItem: tripItem,
                    editDate: editDate,
                    expenditureTab: expenditureTab,
                    isAdd: true,
                    expenseDetail: expenseDetail
                ))
            }
        }
    }

    public enum Action: Equatable {
        case expenditureEdit(ExpendpenditureEditReducer.Action)
        case expenditureBudgetEdit(ExpenditureBudgetEditReducer.Action)
        case setCurrencies([Currency])
        case setCalculationData(ExpenseDetailItem, ExpenditureType)
    }

    public var body: some ReducerOf<ExpenditureUpdateReducer> {
        Reduce { state, action in
            switch action {
            case .expenditureEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
            case .expenditureBudgetEdit(.dismiss):
                cooridinator.dismissRegisterExpense()
                return .none
//            case let .expenditureEdit(.expenditureInput(.tappedCurrencyButton(currency))):
//                if case let .expenditureEdit(editState) = state {
//                    let currencies = editState.currencies
//                    cooridinator.showCurrencyBottomSheet(
//                        currenyList: currencies,
//                        selectedCurrency: currency,
//                        expenseType: state.expenditureTab == .individual ? .individual : .shared
//                    )
//                }
//
//                return .none
//            case let .expenditureBudgetEdit(.expenditureInput(.tappedCurrencyButton(currency))):
//                if case let .expenditureBudgetEdit(budgetEditState) = state {
//                    let currencies = budgetEditState.currencies
//                    cooridinator.showCurrencyBottomSheet(
//                        currenyList: currencies,
//                        selectedCurrency: currency,
//                        expenseType: .individualBudget
//                    )
//                }
//                return .none
//            case .expenditureEdit(.tappedCalculationButton):
//                if case let .expenditureEdit(editState) = state {
//                    let amountString = editState.expenditureInput.text.replacingOccurrences(of: ",", with: "")
//                    if let amount = Double(amountString) {
//                        let expenseText = editState.expenditureCategory.text
//                        let currencyCode = editState.expenditureInput.selectedCurrency.code
//                        let expenseDetail: ExpenseDetailItem = .init(
//                            name: expenseText,
//                            amount: amount,
//                            currency: currencyCode,
//                            payedAt: "",
//                            category: .etc,
//                            payerUserId: nil,
//                            payerList: []
//                        )
//                        cooridinator.pushCalculation(expenseType: .expense, tripItem: state.tripItem, expenseDetail: expenseDetail)
//                    } else {
//                        let toast = Toast.text(icon: .warning, "금액을 입력해주세요.")
//                        toast.show()
//                    }
//                }
//                return .none
//
//            case .expenditureBudgetEdit(.tappedCalculationButton):
//                if case let .expenditureBudgetEdit(budgetEditState) = state {
//                    let amountString = budgetEditState.expenditureInput.text.replacingOccurrences(of: ",", with: "")
//                    if let amount = Double(amountString) {
//                        let expenseText = budgetEditState.expenditureInput.text
//                        let currencyCode = budgetEditState.expenditureInput.selectedCurrency.code
//                        let expenseDetail: ExpenseDetailItem = .init(
//                            name: expenseText,
//                            amount: amount,
//                            currency: currencyCode,
//                            payedAt: "",
//                            category: .etc,
//                            payerUserId: nil,
//                            payerList: []
//                        )
//                        cooridinator.pushCalculation(expenseType: .budget, tripItem: state.tripItem, expenseDetail: expenseDetail)
//                    } else {
//                        let toast = Toast.text(icon: .warning, "금액을 입력해주세요.")
//                        toast.show()
//                    }
//                }
//                return .none
//
//            case .setCalculationData(let expenseDetailItem, let expenseType):
//                switch expenseType {
//                case .expense:
//                    state.expenditureEdit.expenseDetail = expenseDetailItem
//                    state.expenditureEdit.expenditureInput.text = expenseDetailItem.amount.formattedWithSeparator
//                case .budget:
//                    state.expenditureBudgetEdit.expenseDetail = expenseDetailItem
//                    state.expenditureBudgetEdit.expenditureInput.text = expenseDetailItem.amount.formattedWithSeparator
//                }
//                return .none
            default:
                return .none
            }
        }

        Scope(state: /State.expenditureEdit, action: /Action.expenditureEdit) {
            ExpendpenditureEditReducer()
        }

        Scope(state: /State.expenditureBudgetEdit, action: /Action.expenditureBudgetEdit) {
            ExpenditureBudgetEditReducer()
        }
    }
}

