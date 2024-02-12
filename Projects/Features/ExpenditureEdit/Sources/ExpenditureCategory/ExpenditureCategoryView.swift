//
//  ExpenditureCategoryView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureCategoryView: View {
    typealias State = ExpenditureCategoryReducer.State
    typealias Action = ExpenditureCategoryReducer.Action

    let store: StoreOf<ExpenditureCategoryReducer>

    @FocusState var focus: Bool

    var body: some View {
        containerView
    }
}

extension ExpenditureCategoryView {

    @MainActor
    var containerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                Text("카테고리")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.title1))
                Text("*")
                    .foregroundColor(.ybColor(.mainGreen))
                    .font(.ybfont(.body3))
            }
            .padding(.leading, 24)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEachStore(
                        store.scope(
                            state: \.categoryItems,
                            action: ExpenditureCategoryReducer.Action.category
                        )
                    ) { store in
                        ExpenditureCategoryItemView(store: store)
                    }
                }
                .padding(.trailing, 24)
            }
            .padding(.leading, 24)
            WithViewStore(store, observe: { $0 }) { viewStore in
                HStack(alignment: .top, spacing: 10) {
                    HStack(spacing: 0) {
                        Text("지출항목")
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
                                .animation(.default)
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
