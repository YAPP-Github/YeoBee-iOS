//
//  CurrencySheetView.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture

final class CurrencyBottomSheetHostingController: UIHostingController<CurrencySheetView> {
}

struct CurrencySheetView: View {
    typealias State = CurrencySheetReducer.State
    typealias Action = CurrencySheetReducer.Action

    let store: StoreOf<CurrencySheetReducer>

    var body: some View {
        WithViewStore(store, observe: \.currencies) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                Text("통화 선택")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.body1))
                if viewStore.state.count > 3 {
                    ScrollView(.vertical, showsIndicators: false) {
                        contentView
                    }
                } else {
                    contentView
                    Spacer()
                }
            }
        }
    }
}

extension CurrencySheetView {
    private var contentView: some View {
        VStack(spacing: 14) {
            ForEachStore(
                store.scope(
                    state: \.currencies,
                    action: CurrencySheetReducer.Action.currency
                )
            ) { store in
                CurrencyItemView(store: store)
            }
        }
        .padding(.top, 10)
    }
}
