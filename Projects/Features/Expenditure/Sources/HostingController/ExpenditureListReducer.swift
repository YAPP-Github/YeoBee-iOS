//
//  ExpenditureListReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public struct ExpenditureListReducer: Reducer {
    public struct State: Equatable {
        var totalPrice = TotalPriceReducer.State()
        var tripDate = TripDateReducer.State()
    }

    public enum Action {
        case totalPrice(TotalPriceReducer.Action)
        case tripDate(TripDateReducer.Action)
    }

    public var body: some ReducerOf<ExpenditureListReducer> {
        Reduce { _, action in
            switch action {
                default: return .none
            }
        }

        Scope(state: \.totalPrice, action: /Action.totalPrice) {
            TotalPriceReducer()
        }

        Scope(state: \.tripDate, action: /Action.tripDate) {
            TripDateReducer()
        }
    }
}
