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
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                WithViewStore(store, observe: \.isEnableRegisterButton) { viewstore in
                    ScrollView(showsIndicators: false) {
                        containerView
                            .padding(.top, 10)
                            .frame(minHeight: proxy.frame(in: .global).height)
                    }
                    Button {
                        viewstore.send(.tappedRegisterButton)
                    } label: {
                        Text("등록하기")
                            .foregroundColor(viewstore.state ? .ybColor(.white) : .ybColor(.gray5))
                            .font(.ybfont(.title1))
                            .frame(height: 54)
                            .frame(maxWidth: .infinity)
                    }
                    .disabled(viewstore.state == false)
                    .background(viewstore.state ? YBColor.black.swiftUIColor : YBColor.gray3.swiftUIColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 4)
                    .background(YBColor.gray1.swiftUIColor)
                }
            }
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
            WithViewStore(store, observe: \.expenditureTab) { viewStore in
                if viewStore.state == .shared {
                    ExpenseCalculationButtonView {
                        viewStore.send(.tappedCalculationButton)
                    }
                    .padding(.horizontal, 24)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(YBColor.gray1.swiftUIColor)
    }
}
