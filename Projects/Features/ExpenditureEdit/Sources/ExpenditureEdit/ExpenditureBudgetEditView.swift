//
//  ExpenditureBudgetEditView.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureBudgetEditView: View {
    typealias State = ExpenditureBudgetEditReducer.State
    typealias Action = ExpenditureBudgetEditReducer.Action

    let store: StoreOf<ExpenditureBudgetEditReducer>

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
                    .background(viewstore.state ? YBColor.black.swiftUIColor : YBColor.gray3.swiftUIColor)
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 4)
                    .background(YBColor.gray1.swiftUIColor)
                }
            }
            .frame(maxWidth: .infinity)
            .background(YBColor.gray1.swiftUIColor)
            .onAppear { store.send(.onAppear) }
        }
    }
}

extension ExpenditureBudgetEditView {
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
            ExpenditureBudgetContentView(
                store: store.scope(
                    state: \.expenditureContent,
                    action: Action.expenditureContent
                )
            )
            WithViewStore(store, observe: { $0 }) { viewStore in
                if viewStore.expenditureTab == .shared {
                    if viewStore.expenseDetail == nil {
                        ExpenseCalculationButtonView(text: "") {
                            viewStore.send(.tappedCalculationButton)
                        }
                        .padding(.horizontal, 24)
                    } else if let payerName = viewStore.expenseDetail?.payerName {
                        ExpenseCalculationButtonView(text: "\(payerName) 결제") {
                            viewStore.send(.tappedCalculationButton)
                        }
                        .padding(.horizontal, 24)
                    } else {
                        ExpenseCalculationButtonView(text: "공동경비 결제") {
                            viewStore.send(.tappedCalculationButton)
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
            Spacer()
        }
    }
}
