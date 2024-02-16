//
//  FilterBottomSheetItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct FilterBottomSheetItemView: View {
    typealias State = FilterBottomSheetItemReducer.State
    typealias Action = FilterBottomSheetItemReducer.Action

    let store: StoreOf<FilterBottomSheetItemReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button {
                viewStore.send(.tappedExpenseFilter(viewStore.expenseFilter))
            } label: {
                HStack(spacing: 10) {
                    Text(viewStore.expenseFilter?.rawValue ?? "전체보기")
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
