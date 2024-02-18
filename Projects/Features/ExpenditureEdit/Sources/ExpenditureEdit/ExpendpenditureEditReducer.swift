//
//  ExpendpenditureEditReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct ExpendpenditureEditReducer: Reducer {
    public struct State: Equatable {
        var expenditureInput = ExpenditureInputReducer.State()
        var expenditurePayment = ExpenditurePaymentReducer.State()
        var expenditureCategory = ExpenditureCategoryReducer.State()

        var isFocused: Bool = false
        var scrollItem: String = ""
        var isEnableRegisterButton: Bool = false
        var tripItem: TripItem
        var editDate: Date
        let expenditureTab: ExpenditureTab

        init(tripItem: TripItem, editDate: Date, expenditureTab: ExpenditureTab) {
            self.tripItem = tripItem
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
        case expenditureCategory(ExpenditureCategoryReducer.Action)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase

    public var body: some ReducerOf<ExpendpenditureEditReducer> {
        Reduce { state, action in
            switch action {
            case let .expenditureCategory(.setFocusState(isFocused)):
                state.isFocused = isFocused
                state.scrollItem = "expenditureCategoryType"
                return .none
            case .expenditureCategory(.category(_, .tappedCategory)):
                state.isEnableRegisterButton = isEnableRegisterBurron(state: &state)
                return .none
            case .expenditureInput(.binding(\.$text)):
                state.isEnableRegisterButton = isEnableRegisterBurron(state: &state)
                return .none
            case .expenditureCategory(.binding(\.$text)):
                state.isEnableRegisterButton = isEnableRegisterBurron(state: &state)
                return .none
            case .tappedRegisterButton:
                return registerExpense(state: &state)
            default:
                return .none
            }

            func isEnableRegisterBurron(state: inout State) -> Bool {
                return state.expenditureCategory.selectedCategory != nil &&
                    state.expenditureCategory.text.isEmpty == false &&
                    state.expenditureCategory.isInvaildText == false &&
                    state.expenditureInput.text.isEmpty == false
            }

            func registerExpense(state: inout State) -> Effect<Action> {
                let amountString = state.expenditureInput.text.replacingOccurrences(of: ",", with: "")
                if let category = state.expenditureCategory.selectedCategory,
                    let amount = Double(amountString) {
                    let paymentType = state.expenditurePayment.seletedPayment.requestText
                    let expenseText = state.expenditureCategory.text
                    let tripId = state.tripItem.id
                    let currencyCode = state.expenditureInput.selectedCurrency.code
                    let payedAt = state.editDate
                    let expenditureTab = state.expenditureTab
                    return .run { send in
                        let _ = try await expenseUseCase.createExpense(.init(
                            tripId: tripId,
                            payedAt: ISO8601DateFormatter().string(from: payedAt),
                            expenseType: expenditureTab == .shared ? "SHARED" : "INDIVIDUAL",
                            amount: amount,
                            currencyCode: currencyCode,
                            expenseMethod: paymentType,
                            expenseCategory: category.requestText,
                            name: expenseText,
                            payerId: 1
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

        Scope(state: \.expenditureCategory, action: /Action.expenditureCategory) {
            ExpenditureCategoryReducer()
        }
    }
}

extension Payment {
    var requestText: String {
        switch self {
        case .cash: return "CASH"
        case .card: return "CARD"
        }
    }
}


extension Category {
    var requestText: String {
        switch self {
        case .transition: "TRANSPORT"
        case .eating: "FOOD"
        case .stay: "LODGE"
        case .travel: "TRAVEL"
        case .activity: "ACTIVITY"
        case .shopping: "SHOPPING"
        case .air: "FLIGHT"
        case .etc: "ETC"
        }
    }
}
