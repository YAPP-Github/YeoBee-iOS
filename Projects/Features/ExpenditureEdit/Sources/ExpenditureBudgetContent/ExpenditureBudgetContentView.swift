//
//  ExpenditureBudgetContentView.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 1/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureBudgetContentView: View {
    typealias State = ExpenditureBudgetContentReducer.State
    typealias Action = ExpenditureBudgetContentReducer.Action

    let store: StoreOf<ExpenditureBudgetContentReducer>

    @FocusState var focus: Bool

    var body: some View {
        containerView
    }
}

extension ExpenditureBudgetContentView {

    @MainActor
    var containerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            WithViewStore(store, observe: { $0 }) { viewStore in
                HStack(alignment: .top, spacing: 10) {
                    HStack(spacing: 0) {
                        Text("경비내용")
                            .foregroundColor(.ybColor(.black))
                            .font(.ybfont(.title1))
                        Text("*")
                            .foregroundColor(.ybColor(.mainGreen))
                            .font(.ybfont(.body3))
                    }
                        .padding(.top, 12)
                    Spacer()
                    VStack(alignment: .leading) {
                        ExpenditureTextFieldView(text: viewStore.$text, focused: $focus, placeholder: "내용을 입력해주세요.")
                        if viewStore.isInvaildText {
                            Text("한글, 영어 포함 10자 이내로 입력해주세요.")
                                .foregroundColor(.ybColor(.mainRed))
                                .font(.ybfont(.body4))
                        }
                    }
                    .onChange(of: focus, perform: { value in
                        viewStore.send(.setFocusState(value))
                    })
                }
                .padding(.horizontal, 24)
            }
        }

    }
}

