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
        ZStack(alignment: .bottom) {
            ScrollViewReader { reader in
                WithViewStore(store, observe: \.isFocused) { viewstore in
                    ScrollView(showsIndicators: false) {
                        containerView
                            .padding(.top, 10)
                    }
                    .ignoresSafeArea(.keyboard)
                    .onChange(of: viewstore.state, perform: { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
                            withAnimation {
                                reader.scrollTo("expenditureCategoryType", anchor: .center)
                            }
                        }
                    })
                }
            }
            Button {

            } label: {
                Text("등록하기")
                    .foregroundColor(.ybColor(.gray5))
                    .font(.ybfont(.title1))
                    .frame(height: 54)
                    .frame(maxWidth: .infinity)
            }
            .background(YBColor.gray3.swiftUIColor)
            .cornerRadius(10)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 4)
            .background(YBColor.white.swiftUIColor)
            .ignoresSafeArea()
            .ignoresSafeArea(.keyboard)
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
            Color.clear
                .frame(height: 200)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(YBColor.gray1.swiftUIColor)
    }
}
