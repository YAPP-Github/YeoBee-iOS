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
    }
}

extension ExpenditureUpdateView {

    @MainActor
    var containerView: some View {
        VStack(spacing: 10) {
            SwitchStore(store) {
              switch $0 {
              case .expenditureEdit:
                CaseLet(/ExpenditureUpdateReducer.State.expenditureEdit, action: ExpenditureUpdateReducer.Action.expenditureEdit) { store in
                    ExpendpenditureEditView(store: store)
                }
              case .expenditureBudgetEdit:
                CaseLet(/ExpenditureUpdateReducer.State.expenditureBudgetEdit, action: ExpenditureUpdateReducer.Action.expenditureBudgetEdit) { store in
                    ExpenditureBudgetEditView(store: store)
                }
              }
            }
        }
        .background(YBColor.gray1.swiftUIColor, ignoresSafeAreaEdges: [.all])
    }
}
