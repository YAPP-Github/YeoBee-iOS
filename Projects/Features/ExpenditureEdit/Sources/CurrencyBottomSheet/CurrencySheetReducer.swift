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

        public init(currencyList: [Currency], selectedCurrency: Currency? = nil) {
            self.selectedCurrency = selectedCurrency
            self.currenyList = currencyList
            currencyList.forEach {
                var isSelected = false
                if let selectedCurrency { isSelected = $0 == selectedCurrency }
                self.currencies.updateOrAppend(.init(currency: $0, isSelected: isSelected))
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
                cooridinator.selectCurrency(curreny: selectedCurrency)
                return .none
            }
        }
        .forEach(\.currencies, action: /Action.currency) {
            CurrencyItemReducer()
        }
    }
}
