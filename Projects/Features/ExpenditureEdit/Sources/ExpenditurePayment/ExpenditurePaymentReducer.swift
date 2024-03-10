//
//  ExpenditurePaymentReducer.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture

public enum Payment {
    case cash, card
}

public struct ExpenditurePaymentReducer: Reducer {
    public struct State: Equatable {
        var isExpense: Bool
        var isShared: Bool
        var seletedPayment: Payment = .cash
        init(isExpense: Bool, isShared: Bool) {
            self.isExpense = isExpense
            self.isShared = isShared
        }
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
