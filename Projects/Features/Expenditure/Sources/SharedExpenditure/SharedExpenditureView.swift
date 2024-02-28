//
//  SharedExpenditureView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import UIKit
import ComposableArchitecture
import DesignSystem
import Entity

final class SharedExpenditureHostingController: UIHostingController<SharedExpenditureView> {
}

struct SharedExpenditureView: View {
    typealias State = SharedExpenditureReducer.State
    typealias Action = SharedExpenditureReducer.Action

    let store: StoreOf<SharedExpenditureReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 4) {
                ExpenditureToggleView(
                    expenditureTab: viewStore.$selectedTab)
                    .frame(width: 200, height: 40)
                    .padding(.top, 5)
                TabView(selection: viewStore.$selectedTab) {
                    ExpenditureView(
                        store: store.scope(
                            state: \.sharedExpenditure,
                            action: SharedExpenditureReducer.Action.sharedExpenditure
                        )
                    )
                    .tag(ExpenditureTab.shared)
                    .highPriorityGesture(DragGesture())
                    ExpenditureView(
                        store: store.scope(
                            state: \.individualExpenditure,
                            action: SharedExpenditureReducer.Action.individualExpenditure
                        )
                    )
                    .tag(ExpenditureTab.individual)
                    .highPriorityGesture(DragGesture())
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .background(YBColor.gray1.swiftUIColor)
        }
    }
}
