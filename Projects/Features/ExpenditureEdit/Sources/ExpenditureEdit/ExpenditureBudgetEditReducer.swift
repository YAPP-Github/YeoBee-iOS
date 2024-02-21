//
//  ExpenditureBudgetEditReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct ExpenditureBudgetEditReducer: Reducer {
    public struct State: Equatable {
        var expenditureInput = ExpenditureInputReducer.State()
        var expenditurePayment = ExpenditurePaymentReducer.State()
        var expenditureContent = ExpenditureBudgetContentReducer.State()

        var isFocused: Bool = false
        var scrollItem: String = ""
        var isEnableRegisterButton: Bool = false
        var tripItem: TripItem
        var expenseItem: ExpenseItem?
        var editDate: Date
        let expenditureTab: ExpenditureTab
        var expenseDetail: ExpenseDetailItem?
        var currencies: [Currency] = []
        var isInitialShow: Bool = true
        var hasSharedBudget: Bool

        init(
            expenseItem: ExpenseItem?,
            tripItem: TripItem,
            editDate: Date,
            expenditureTab: ExpenditureTab,
            expenseDetail: ExpenseDetailItem?,
            hasSharedBudget: Bool
        ) {
            self.expenseItem = expenseItem
            self.tripItem = tripItem
            self.editDate = editDate
            self.expenditureTab = expenditureTab
            self.expenseDetail = expenseDetail
            self.hasSharedBudget = hasSharedBudget
        }
    }

    public enum Action: Equatable {
        case onAppear
        case tappedRegisterButton
        case tappedCalculationButton
        case dismiss
        case updateDimiss(CreateExpenseResponse)

        case setCurrencies([Currency])
        case setExpenditureDetail(ExpenseDetailItem)
        case setEditExpense(ExpenseDetailItem, [Currency])

        case expenditureInput(ExpenditureInputReducer.Action)
        case expenditurePayment(ExpenditurePaymentReducer.Action)
        case expenditureContent(ExpenditureBudgetContentReducer.Action)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase
    @Dependency(\.currencyUseCase) var currencyUseCase

    public var body: some ReducerOf<ExpenditureBudgetEditReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.isInitialShow {
                    state.isInitialShow = false
                    return .run { [tripId = state.tripItem.id, state] send in
                        let currencies = try await currencyUseCase.getTripCurrencies(tripId)
                        if let expenseDetail = state.expenseDetail {
                            await send(.setEditExpense(expenseDetail, currencies))
                        }
                        await send(.setCurrencies(currencies))
                    } catch: { error, send in
                        print(error)
                    }
                }
                return .none

            case let .setCurrencies(currencyList):
                state.currencies = currencyList
                return .none

            case .expenditureInput(.binding(\.$text)):
                state.isEnableRegisterButton = isEnableRegisterBurron(state: &state)
                return .none

            case .expenditureContent(.binding(\.$text)):
                state.isEnableRegisterButton = isEnableRegisterBurron(state: &state)
                return .none

            case .tappedRegisterButton:
                return registerExpense(state: &state)

            case let .setEditExpense(expenseDetail, currencies):
                let currency = currencies.filter { $0.code == expenseDetail.currency }.first
                state.expenseDetail = expenseDetail
                return .run { send in
                    await send(.expenditureInput(.setInput(expenseDetail.amount.formattedWithSeparator, currency)))
                    await send(.expenditureContent(.setTextField(expenseDetail.name)))
                    await send(.expenditurePayment(.setPayment(expenseDetail.method == "CASH" ? .cash : .card)))
                }

            default:
                return .none
            }

            func isEnableRegisterBurron(state: inout State) -> Bool {
                if state.expenditureTab == .individual {
                    return state.expenditureContent.text.isEmpty == false &&
                    state.expenditureContent.isInvaildText == false &&
                    state.expenditureInput.text.isEmpty == false
                } else {
                    return state.expenditureContent.text.isEmpty == false &&
                    state.expenditureContent.isInvaildText == false &&
                    state.expenditureInput.text.isEmpty == false &&
                    state.expenseDetail != nil &&
                    state.expenseDetail?.payerList != []
                }
            }

            func registerExpense(state: inout State) -> Effect<Action> {
                let amountString = state.expenditureInput.text.replacingOccurrences(of: ",", with: "")
                if let amount = Double(amountString) {
                    let paymentType = state.expenditurePayment.seletedPayment.requestText
                    let tripId = state.tripItem.id
                    let currencyCode = state.expenditureInput.selectedCurrency.code
                    let expenseText = state.expenditureContent.text
                    let payedAt = state.editDate
                    let expenditureTab = state.expenditureTab
                    let payerId = state.expenseDetail?.payerId
                    let payerList: [PayerRequest] = state.expenseDetail?.payerList.compactMap { 
                        .init(tripUserId: $0.tripUserId, amount: $0.amount)
                    } ?? []
                    return .run { [state] send in
                        let payedDate = Calendar.current.date(byAdding: .hour, value: 9, to: payedAt) ?? Date()
                        if let expenseItem = state.expenseItem {
                            let result = try await expenseUseCase.updateExpense(expenseItem.id, .init(
                                tripId: tripId,
                                payedAt: ISO8601DateFormatter().string(from: payedDate),
                                expenseType: expenditureTab == .shared ? "SHARED_BUDGET_INCOME" : "INDIVIDUAL_BUDGET_INCOME",
                                amount: amount,
                                currencyCode: currencyCode,
                                expenseMethod: paymentType,
                                expenseCategory: "INCOME",
                                name: expenseText,
                                payerId: payerId,
                                payerList: payerList
                            ))
                            await send(.updateDimiss(result))
                        } else {
                            let _ = try await expenseUseCase.createExpense(.init(
                                tripId: tripId,
                                payedAt: ISO8601DateFormatter().string(from: payedDate),
                                expenseType: expenditureTab == .shared ? "SHARED_BUDGET_INCOME" : "INDIVIDUAL_BUDGET_INCOME",
                                amount: amount,
                                currencyCode: currencyCode,
                                expenseMethod: paymentType,
                                expenseCategory: "INCOME",
                                name: expenseText,
                                payerId: payerId,
                                payerList: payerList
                            ))
                            await send(.dismiss)
                        }
                    } catch: { error, send in
                        print(error)
                    }
                }
                return .none
            }
        }

        Scope(state: \.expenditureInput, action: /Action.expenditureInput) {
            ExpenditureInputReducer()
        }

        Scope(state: \.expenditurePayment, action: /Action.expenditurePayment) {
            ExpenditurePaymentReducer()
        }

        Scope(state: \.expenditureContent, action: /Action.expenditureContent) {
            ExpenditureBudgetContentReducer()
        }
    }
}
