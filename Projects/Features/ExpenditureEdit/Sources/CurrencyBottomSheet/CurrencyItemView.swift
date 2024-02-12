//
//  CurrencyItemView.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct CurrencyItemView: View {
    typealias State = CurrencyItemReducer.State
    typealias Action = CurrencyItemReducer.Action

    let store: StoreOf<CurrencyItemReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.tappedCurrency(viewStore.currency))
            } label: {
                HStack(spacing: 10) {
                    Text(viewStore.currency.code + " (\(viewStore.currency.name))")
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body1))
                    Spacer()
                    if viewStore.isSelected {
                        DesignSystemAsset.Icons.checkFill.swiftUIImage
                            .frame(width: 28, height: 28)
                    } else {
                        DesignSystemAsset.Icons.uncheck.swiftUIImage
                            .frame(width: 28, height: 28)
                    }

                }
            }
        }
    }
}
