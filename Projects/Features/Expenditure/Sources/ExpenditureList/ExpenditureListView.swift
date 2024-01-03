//
//  ExpenditureListView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture

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
        VStack(alignment: .leading, spacing: 20) {
            FilterButtonView(title: "전체보기")
            VStack(spacing: 14) {
                ForEachStore(
                    store.scope(
                        state: \.expenditureListItems,
                        action: ExpenditureListReducer.Action.expenditureListItem)
                ) { store in
                    ExpenditureListItemView(store: store)
                }
                Spacer()
            }
        }
    }
}
