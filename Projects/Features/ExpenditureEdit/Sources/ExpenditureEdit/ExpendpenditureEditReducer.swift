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
        var expenseItem: ExpenseItem?
        var editDate: Date
        let expenditureTab: ExpenditureTab
        var expenseDetail: ExpenseDetailItem
        var firstExpenseDetail: ExpenseDetailItem?
        var currencies: [Currency] = []
        var isInitialShow: Bool = true
        var hasSharedBudget: Bool
        var isUpdate: Bool

        init(
            expenseItem: ExpenseItem?,
            tripItem: TripItem,
            editDate: Date,
            expenditureTab: ExpenditureTab,
            expenseDetail: ExpenseDetailItem?,
            hasSharedBudget: Bool,
            isUpdate: Bool
        ) {
            self.expenseItem = expenseItem
            self.tripItem = tripItem
            self.editDate = editDate
            self.expenditureTab = expenditureTab
            self.firstExpenseDetail = expenseDetail
            self.hasSharedBudget = hasSharedBudget
            self.isUpdate = isUpdate
            if let expenseDetail {
                self.expenseDetail = expenseDetail
            } else {
                var expenseList: [Payer] = []
                tripItem.tripUserList.forEach { tripUser in
                    expenseList.append(.init(tripUserId: tripUser.id, amount: 0))
                }
                let expenseDetail: ExpenseDetailItem = .init(
                    name: "",
                    amount: 0,
                    currency: "",
                    payedAt: "",
                    category: .etc,
                    payerUserId: nil,
                    payerId: hasSharedBudget ? nil : tripItem.tripUserList.first?.id,
                    payerList: expenseList,
                    method: "",
                    calculationType: "EQUAL"
                )
                self.expenseDetail = expenseDetail
            }
        }
    }

    public enum Action: Equatable {
        case onAppear
        case tappedRegisterButton
        case tappedCalculationButton
        case dismiss
        case updateDimiss(CreateExpenseResponse)

        case setCurrencies([Currency])
        case setEditExpense(ExpenseDetailItem, [Currency])
        case setExpenditureDetail(ExpenseDetailItem)

        case expenditureInput(ExpenditureInputReducer.Action)
        case expenditurePayment(ExpenditurePaymentReducer.Action)
        case expenditureCategory(ExpenditureCategoryReducer.Action)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase
    @Dependency(\.currencyUseCase) var currencyUseCase

    public var body: some ReducerOf<ExpendpenditureEditReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.isInitialShow {
                    state.isInitialShow = false
                    return .run { [tripId = state.tripItem.id, state] send in
                        let currencies = try await currencyUseCase.getTripCurrencies(tripId)
                        if state.isUpdate {
                            await send(.setEditExpense(state.expenseDetail, currencies))
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

            case let .setExpenditureDetail(expenseDetailItem):
                if state.isUpdate {
                    state.expenseDetail.calculationType = expenseDetailItem.calculationType
                    state.expenseDetail.payerList = expenseDetailItem.payerList
                    state.expenseDetail.payerName = expenseDetailItem.payerName
                    state.expenseDetail.payerId = expenseDetailItem.payerId
                } else {
                    state.expenseDetail = expenseDetailItem
                }
                return .none

            case let .setEditExpense(expenseDetail, currencies):
                let currency = currencies.filter { $0.code == expenseDetail.currency }.first
                return .run { send in
                    await send(.expenditureInput(.setInput(expenseDetail.amount.formattedWithSeparator, currency)))
                    await send(.expenditureCategory(.setCategory(expenseDetail.category.convert, expenseDetail.name)))
                    await send(.expenditurePayment(.setPayment(expenseDetail.method == "CASH" ? .cash : .card)))
                }

            default:
                return .none
            }

            func isEnableRegisterBurron(state: inout State) -> Bool {
                if state.expenditureTab == .individual {
                    return state.expenditureCategory.selectedCategory != nil &&
                        state.expenditureCategory.text.isEmpty == false &&
                        state.expenditureCategory.isInvaildText == false &&
                        state.expenditureInput.text.isEmpty == false
                } else {
                    return state.expenditureCategory.selectedCategory != nil &&
                        state.expenditureCategory.text.isEmpty == false &&
                        state.expenditureCategory.isInvaildText == false &&
                        state.expenditureInput.text.isEmpty == false &&
                        state.expenseDetail.payerList != []
                }
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
                    let payerId = state.expenseDetail.payerId
                    let calculationType = state.expenseDetail.calculationType
                    let payerList: [PayerRequest] = state.expenseDetail.payerList.compactMap {
                        if $0.amount == 0 {
                            let dutchAmount =  amount / Double(state.expenseDetail.payerList.count)
                            return .init(tripUserId: $0.tripUserId, amount: dutchAmount)
                        } else {
                            return .init(tripUserId: $0.tripUserId, amount: $0.amount)
                        }
                    }
                    return .run { [state] send in
                        let payedDate = Calendar.current.date(byAdding: .hour, value: 9, to: payedAt) ?? Date()
                        print(payedDate)
                        if let expenseItem = state.expenseItem,
                           state.isUpdate {
                            let result = try await expenseUseCase.updateExpense(expenseItem.id, .init(
                                tripId: tripId,
                                payedAt: ISO8601DateFormatter().string(from: payedDate),
                                expenseType: expenditureTab == .shared ? "SHARED" : "INDIVIDUAL",
                                amount: amount,
                                currencyCode: currencyCode,
                                expenseMethod: paymentType,
                                expenseCategory: category.requestText,
                                name: expenseText,
                                payerId: payerId,
                                payerList: payerList,
                                calculationType: expenditureTab == .shared ? calculationType : "NONE"
                            ))
                            await send(.updateDimiss(result))
                        } else {
                            let _ = try await expenseUseCase.createExpense(.init(
                                tripId: tripId,
                                payedAt: ISO8601DateFormatter().string(from: payedDate),
                                expenseType: expenditureTab == .shared ? "SHARED" : "INDIVIDUAL",
                                amount: amount,
                                currencyCode: currencyCode,
                                expenseMethod: paymentType,
                                expenseCategory: category.requestText,
                                name: expenseText,
                                payerId: payerId,
                                payerList: payerList,
                                calculationType: expenditureTab == .shared ? calculationType : "NONE"
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

extension ExpendCategory {
    var convert: Category {
        switch self {
        case .transport: Category.transition
        case .food: Category.eating
        case .lodge: Category.stay
        case .travel: Category.travel
        case .activity: Category.activity
        case .flight: Category.air
        case .shopping: Category.shopping
        case .etc: Category.etc
        case .income: Category.travel
        }
    }
}
