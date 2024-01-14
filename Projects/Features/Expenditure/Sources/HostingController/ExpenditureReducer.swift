//
//  ExpenditureReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureReducer: Reducer {

    let cooridinator: ExpenditureCoordinator

    init(cooridinator: ExpenditureCoordinator) {
        self.cooridinator = cooridinator
    }

    public struct State: Equatable {
        var type: ExpenditureTab
        var totalPrice: TotalPriceReducer.State
        var tripDate = TripDateReducer.State()
        var expenditureList = ExpenditureListReducer.State()

        init(type: ExpenditureTab) {
            self.type = type
            self.totalPrice = .init(type: type)
        }
    }

    public enum Action {
        case totalPrice(TotalPriceReducer.Action)
        case tripDate(TripDateReducer.Action)
        case expenditureList(ExpenditureListReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureReducer> {
        Reduce { state, action in
            switch action {
            case .tripDate(.tappedTripReadyButton):
                return .send(.expenditureList(.setExpenditures([])))
            case let .tripDate(.tripDateItem(id: id, action: .tappedItem)):
                let date = state.tripDate.tripDateItems[id: id]?.date
                return .send(.expenditureList(.setExpenditures([
                    .init(expenseType: .expense, title: "8글자까지보이기안보이면어떡하징", price: 100051353216, currency: .usd, category: .activity),
                    .init(expenseType: .income, title: "파스타", price: 5000, currency: .krw, category: .activity),
                    .init(expenseType: .expense, title: "저는 이번주에 일본갑니다", price: 54800, currency: .jpy, category: .air),
                    .init(expenseType: .expense, title: "부럽죠", price: 6421, currency: .jpy, category: .etc),
                    .init(expenseType: .expense, title: "여러분 선물 사올게요", price: 558588422, currency: .eur, category: .eating),
                    .init(expenseType: .expense, title: "꺄아아아ㅏㅇ", price: 123123, currency: .usd, category: .transition),
                    .init(expenseType: .expense, title: "8글자까지보이기안보이면어떡하징", price: 7000, currency: .krw, category: .travel),
                    .init(expenseType: .income, title: "태태제리제로화이팅", price: 100, currency: .jpy, category: .stay),
                    .init(expenseType: .expense, title: "여비팀화이팅", price: 87000, currency: .eur, category: .etc),
                ])))
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
