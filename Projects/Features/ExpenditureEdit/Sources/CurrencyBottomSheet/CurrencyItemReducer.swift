//
//  CurrencyItemReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct CurrencyItemReducer: Reducer {
    
    public struct State: Equatable, Identifiable {
        public var id: String { return currency.code }
        var currency: Currency
        var isSelected: Bool

        init(currency: Currency, isSelected: Bool = false) {
            self.currency = currency
            self.isSelected = isSelected
        }
    }

    public enum Action {
        case tappedCurrency(Currency)
    }

    public var body: some ReducerOf<CurrencyItemReducer> {
        EmptyReducer()
    }
}
