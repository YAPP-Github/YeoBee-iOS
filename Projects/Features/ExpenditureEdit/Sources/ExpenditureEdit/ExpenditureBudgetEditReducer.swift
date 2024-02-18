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
        var tripId: Int
        var editDate: Date
        let expenditureTab: ExpenditureTab
        var expenseDetail: ExpenseDetailItem?

        init(tripId: Int, editDate: Date, expenditureTab: ExpenditureTab) {
            self.tripId = tripId
            self.editDate = editDate
            self.expenditureTab = expenditureTab
        }
    }

    public enum Action: Equatable {
        case tappedRegisterButton
        case tappedCalculationButton
        case dismiss

        case expenditureInput(ExpenditureInputReducer.Action)
        case expenditurePayment(ExpenditurePaymentReducer.Action)
        case expenditureContent(ExpenditureBudgetContentReducer.Action)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase

    public var body: some ReducerOf<ExpenditureBudgetEditReducer> {
        Reduce { state, action in
            switch action {
            case .expenditureInput(.binding(\.$text)):
                state.isEnableRegisterButton = isEnableRegisterBurron(state: &state)
                return .none
            case .expenditureContent(.binding(\.$text)):
                state.isEnableRegisterButton = isEnableRegisterBurron(state: &state)
                return .none
            case .tappedRegisterButton:
                return registerExpense(state: &state)
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
                    state.expenseDetail?.payerUserId != nil &&
                    state.expenseDetail?.payerList != []
                }
            }

            func registerExpense(state: inout State) -> Effect<Action> {
                let amountString = state.expenditureInput.text.replacingOccurrences(of: ",", with: "")
                if let amount = Double(amountString) {
                    let paymentType = state.expenditurePayment.seletedPayment.requestText
                    let tripId = state.tripId
                    let currencyCode = state.expenditureInput.selectedCurrency.code
                    let expenseText = state.expenditureContent.text
                    let payedAt = state.editDate
                    let expenditureTab = state.expenditureTab
                    let payerId = state.expenseDetail?.payerUserId
                    let payerList: [PayerRequest] = state.expenseDetail?.payerList.compactMap { 
                        .init(tripUserId: $0.userId, amount: $0.amount)
                    } ?? []
                    return .run { send in
                        let _ = try await expenseUseCase.createExpense(.init(
                            tripId: tripId,
                            payedAt: ISO8601DateFormatter().string(from: payedAt),
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
