//
//  CurrencySheetReducer.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import Foundation
import ComposableArchitecture
import Entity

public struct CurrencySheetReducer: Reducer {

    let cooridinator: ExpenditureAddCoordinator

    init(cooridinator: ExpenditureAddCoordinator) {
        self.cooridinator = cooridinator
    }
    
    public struct State: Equatable {
        var currencies: IdentifiedArrayOf<CurrencyItemReducer.State> = []
        let currenyList: [Currency]
        var selectedCurrency: Currency?
        var expenseType: ExpenseType

        public init(currencyList: [Currency], selectedCurrency: Currency, expenseType: ExpenseType) {
            self.selectedCurrency = selectedCurrency
            self.currenyList = currencyList
            self.expenseType = expenseType
            currencyList.forEach {
                self.currencies.updateOrAppend(.init(currency: $0, isSelected: $0.code == selectedCurrency.code))
            }
        }
    }

    public enum Action {
        case currency(CurrencyItemReducer.State.ID, CurrencyItemReducer.Action)
    }

    public var body: some ReducerOf<CurrencySheetReducer> {
        Reduce { state, action in
            switch action {
            case let .currency(_, .tappedCurrency(selectedCurrency)):
                state.currenyList.forEach { currency in
                    state.currencies.updateOrAppend(.init(
                        currency: currency,
                        isSelected: currency == selectedCurrency
                    ))
                }
                state.selectedCurrency = selectedCurrency
                cooridinator.selectCurrency(curreny: selectedCurrency, expenseType: state.expenseType)
                return .none
            }
        }
        .forEach(\.currencies, action: /Action.currency) {
            CurrencyItemReducer()
        }
    }
}
