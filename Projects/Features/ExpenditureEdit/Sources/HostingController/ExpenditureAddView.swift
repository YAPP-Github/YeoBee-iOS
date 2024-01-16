//
//  ExpenditureView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import UIKit
import ComposableArchitecture
import DesignSystem

final class ExpenditureAddHostingController: UIHostingController<ExpenditureAddView> {
}

struct ExpenditureAddView: View {
    typealias State = ExpenditureReducer.State
    typealias Action = ExpenditureReducer.Action

    let store: StoreOf<ExpenditureReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureAddView {

    @MainActor
    var containerView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 10) {
                ExpenditureToggleView(expenditureTab: viewStore.$seletedExpenditureType)
                .frame(height: 40)
                .padding(.horizontal, 24)
                TabView(selection: viewStore.$seletedExpenditureType) {
                    ExpendpenditureEditView(
                       store: store.scope(
                        state: \.expenditureEdit,
                        action: ExpenditureReducer.Action.expenditureEdit
                       )
                    )
                    .tag(ExpenditureTab.shared)
                    ExpenditureBudgetEditView(
                       store: store.scope(
                        state: \.expenditureBudgetEdit,
                        action: ExpenditureReducer.Action.expenditureBudgetEdit
                       )
                    )
                    .tag(ExpenditureTab.individual)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .background(YBColor.gray1.swiftUIColor, ignoresSafeAreaEdges: [.all])
        }
    }
}
