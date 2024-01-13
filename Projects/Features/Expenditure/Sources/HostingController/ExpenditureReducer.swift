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
        Reduce { _, action in
            switch action {
            case .tripDate(.tappedTripReadyButton):
                cooridinator.test()
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
