//
//  ExpenditurePaymentReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Combine
import ComposableArchitecture

public enum Payment {
    case cash, card
}

public struct ExpenditurePaymentReducer: Reducer {
    public struct State: Equatable {
        var seletedPayment: Payment = .cash
    }

    public enum Action: Equatable {
        case setPayment(Payment)
    }
    public var body: some ReducerOf<ExpenditurePaymentReducer> {
        Reduce { state, action in
            switch action {
            case let .setPayment(payment):
                state.seletedPayment = payment
                return .none
            }
        }
    }
}
