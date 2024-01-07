//
//  ExpendpenditureEditView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpendpenditureEditView: View {
    typealias State = ExpendpenditureEditReducer.State
    typealias Action = ExpendpenditureEditReducer.Action

    let store: StoreOf<ExpendpenditureEditReducer>

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                containerView
            }
            .padding(.top, 10)
        }
    }
}

extension ExpendpenditureEditView {
    var containerView: some View {
        VStack(spacing: 20) {
            ExpenditureInputView(
                store: store.scope(
                    state: \.expenditureInput,
                    action: Action.expenditureInput
                )
            )
            ExpenditurePaymentView(
                store: store.scope(
                    state: \.expenditurePayment,
                    action: Action.expenditurePayment
                )
            )
            ExpenditureCategoryView(
                store: store.scope(
                    state: \.expenditureCategory,
                    action: Action.expenditureCategory
                )
            )
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(YBColor.gray1.swiftUIColor)
    }
}
