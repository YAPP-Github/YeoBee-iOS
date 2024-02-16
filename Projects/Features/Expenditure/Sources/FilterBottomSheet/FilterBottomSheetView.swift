//
//  FilterBottomSheetView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

final class FilterBottomSheettHostingController: UIHostingController<FilterBottomSheetView> {
}

struct FilterBottomSheetView: View {
    typealias State = FilterBottomSheetReducer.State
    typealias Action = FilterBottomSheetReducer.Action

    let store: StoreOf<FilterBottomSheetReducer>

    var body: some View {
        WithViewStore(store, observe: \.expenseFilterStates) { viewStore in
            VStack(alignment: .leading, spacing: 10) {
                Text("보기 방식")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.title1))
                if viewStore.state.count > 3 {
                    ScrollView(.vertical, showsIndicators: false) {
                        contentView
                    }
                } else {
                    contentView
                    Spacer()
                }
            }
            .padding(.top, 15)
        }
    }
}

extension FilterBottomSheetView {
    private var contentView: some View {
        VStack(spacing: 14) {
            ForEachStore(
                store.scope(
                    state: \.expenseFilterStates,
                    action: FilterBottomSheetReducer.Action.expenseFilter
                )
            ) { store in
                FilterBottomSheetItemView(store: store)
            }
        }
        .padding(.top, 10)
    }
}
