//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import UseCase
import Entity

public struct ExpenditureReducer: Reducer {

    let cooridinator: ExpenditureCoordinator

    init(cooridinator: ExpenditureCoordinator) {
        self.cooridinator = cooridinator
    }
    public struct State: Equatable {
        var type: ExpenditureTab
        var totalPrice: TotalPriceReducer.State
        var tripDate: TripDateReducer.State
        var expenditureList = ExpenditureListReducer.State()
        let tripItem: TripItem
        var isInitialShow: Bool = true
        var pageIndex: Int = 0
        var isLastPage: Bool = false
        var currentDate: Date?
        var currentFilter: PaymentMethod?
        var startDate: Date
        var endDate: Date
        var readyDate: Date
        var selectedDate: Date?

        init(type: ExpenditureTab, tripItem: TripItem) {
            self.type = type
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let startDate = dateFormatter.date(from: tripItem.startDate) ?? Date()
            let endDate = dateFormatter.date(from: tripItem.endDate) ?? Date()
            let readyDate = Calendar.current.date(byAdding: .day, value: 1, to: startDate) ?? Date()
            self.tripItem = tripItem
            self.startDate = startDate
            self.endDate = endDate
            self.readyDate = readyDate
            self.tripDate = TripDateReducer.State(startDate: startDate, endDate: endDate)
            self.totalPrice = .init(
                expenseType: type,
                totalPriceType: .expense,
                isTappable: true
            )
        }
    }

    public enum Action {
        case onAppear
        case getExpenseList(Date)
        case totalPrice(TotalPriceReducer.Action)
        case tripDate(TripDateReducer.Action)
        case expenditureList(ExpenditureListReducer.Action)
        case tappedAddButton
        case tappedFilterButton(PaymentMethod?)
        case getExpenditure(Date)
        case getBudget
        case appendExpenditures
        case setLastPage(Bool)
        case setExpenseFilter(PaymentMethod?)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase
    @Dependency(\.tripCalculationUseCase) var tripCalculationUseCase

    public var body: some ReducerOf<ExpenditureReducer> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("trip data", state.tripItem)
                let currentDate = Date()
                if state.isInitialShow {
                    state.isInitialShow = false
                    let selectDate: Date
                    if currentDate < state.startDate {
                        selectDate = state.readyDate
                    } else if currentDate > state.endDate {
                        selectDate = state.startDate
                    } else {
                        selectDate = currentDate
                    }
                    return .run { send in
                        await send(.tripDate(.selectDate(selectDate)))
                        await send(.getExpenditure(selectDate))
                        await send(.getBudget)
                    }
                } else {
                    return .none
                }

            case let .getExpenseList(selectDate):
                return .run { send in
                    await send(.tripDate(.selectDate(selectDate)))
                    await send(.getExpenditure(selectDate))
                }

            case .tripDate(.tappedTripReadyButton):
                return .send(.getExpenditure(state.readyDate))

            case let .tripDate(.tripDateItem(id: id, action: .tappedItem)):
                guard let tripDate = state.tripDate.tripDateItems[id: id]?.date else { return .none }
                return .send(.getExpenditure(tripDate))

            case let .getExpenditure(tripDate):
                var isReset: Bool = false
                if state.currentDate == nil || tripDate != state.currentDate {
                    state.pageIndex = 0
                    state.currentDate = tripDate
                    state.isLastPage = false
                    isReset = true
                } else {
                    state.pageIndex += 1
                }
                return .run { [
                    pageIndex = state.pageIndex,
                    isReset,
                    tripId = state.tripItem.id,
                    expenseMethod = state.currentFilter,
                    expenseType = state.type
                ] send in
                    let (expenseItems, isLastPage) = try await expenseUseCase.getExpenseList(
                        tripId,
                        tripDate,
                        expenseType == .individual ? .individual : .shared,
                        expenseMethod,
                        pageIndex
                    )
                    await send(.expenditureList(.setExpenditures(expenseItems, isReset)))
                    await send(.setLastPage(isLastPage))
                } catch: { error, send in
                    print(error)
                    await send(.setLastPage(true))
                }

            case .tappedAddButton:
                let selectedDate = state.tripDate.selectedDate ?? state.readyDate
                cooridinator.expenditureAdd(
                    tripItem: state.tripItem,
                    editDate: selectedDate,
                    expenditureTab: state.type
                )
                return .none

            case .totalPrice(.tappedTotalPrice):
                cooridinator.totalExpenditureList()
                return .none

            case .totalPrice(.tappedBubgetPrice):
                cooridinator.totalBudgetExpenditureList()
                return .none

            case .getBudget:
                return .run { [tripId = state.tripItem.id] send in
                    if let budget = try await tripCalculationUseCase.getBudget(tripId).individualBudget {
                        await send(.totalPrice(.setTotalPrice(budget.budgetExpense, budget.budgetIncome, budget.leftBudget)))
                    }
                } catch: { error, send in
                    print(error)
                }

            case let .tappedFilterButton(selectedExpense):
                cooridinator.showFilterBottomSheet(selectedExpenseFilter: selectedExpense)
                return .none

            case let .expenditureList(.expenditureListItem(id: _, action: .tappedExpenditureItem(expenseItem))):
                cooridinator.expenditureDetail(expenseItem: expenseItem)
                return .none

            case .appendExpenditures:
                if let currentDate = state.currentDate, state.isLastPage == false {
                    return .send(.getExpenditure(currentDate))
                }
                return .none

            case let .setLastPage(isLastPage):
                state.pageIndex = 0
                state.isLastPage = isLastPage
                return .none

            case let .setExpenseFilter(expenseFilter):
                state.currentFilter = expenseFilter
                if let currentDate = state.currentDate {
                    state.pageIndex = -1
                    return .send(.getExpenditure(currentDate))
                }
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
