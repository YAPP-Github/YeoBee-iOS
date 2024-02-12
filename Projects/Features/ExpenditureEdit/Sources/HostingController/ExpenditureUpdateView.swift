//
//  ExpenditureEditView.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import UIKit
import ComposableArchitecture
import DesignSystem

final class ExpenditureUpdateHostingController: UIHostingController<ExpenditureUpdateView> {
}

struct ExpenditureUpdateView: View {
    typealias State = ExpenditureUpdateReducer.State
    typealias Action = ExpenditureUpdateReducer.Action

    let store: StoreOf<ExpenditureUpdateReducer>

    var body: some View {
        containerView
            .onAppear { store.send(.onAppear) }
    }
}

extension ExpenditureUpdateView {

    @MainActor
    var containerView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 10) {
                SwitchStore(store.scope(state: \.expenditureEditRoute, action: { $0 })) { _ in
                    CaseLet(
                        /ExpenditureUpdateReducer.State.ExpenditureEditRoute.expenditureEdit,
                        action: ExpenditureUpdateReducer.Action.expenditureEdit,
                        then: ExpendpenditureEditView.init
                    )
//                    CaseLet(
//                        /ExpenditureUpdateReducer.State.ExpenditureEditRoute.expenditureBudgetEdit,
//                        action: ExpenditureUpdateReducer.Action.expenditureBudgetEdit,
//                        then: ExpenditureBudgetEditView.init
//                    )
                }
            }
            .background(YBColor.gray1.swiftUIColor, ignoresSafeAreaEdges: [.all])
        }
    }
}
