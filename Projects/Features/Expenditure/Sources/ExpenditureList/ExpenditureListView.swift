//
//  ExpenditureListView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureListView: View {
    typealias State = ExpenditureListReducer.State
    typealias Action = ExpenditureListReducer.Action

    let store: StoreOf<ExpenditureListReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureListView {
    var containerView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if viewStore.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    DesignSystemAsset.Icons.emptyImage.swiftUIImage
                        .frame(width: 95, height: 84)
                    Text("내역이 없어요.")
                        .foregroundColor(.ybColor(.black))
                        .font(.ybfont(.body2))
                    Spacer()
                }
            } else {
                VStack(spacing: 14) {
                    ForEachStore(
                        store.scope(
                            state: \.expenditureListItems,
                            action: ExpenditureListReducer.Action.expenditureListItem
                        )
                    ) { store in
                        ExpenditureListItemView(store: store)
                    }
                    
                }
            }
        }
    }
}
