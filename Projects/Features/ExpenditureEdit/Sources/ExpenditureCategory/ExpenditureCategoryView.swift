//
//  ExpenditureCategoryView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ExpenditureCategoryView: View {
    typealias State = ExpenditureCategoryReducer.State
    typealias Action = ExpenditureCategoryReducer.Action

    let store: StoreOf<ExpenditureCategoryReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureCategoryView {
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
            }
            HStack(alignment: .center, spacing: 10) {
                Text("지출항목")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.title1))
                Spacer()
                ExpenditureTextFieldView(text: .constant("123"), placeholder: "내용을 입력해주세요.")
            }
        }
        .padding(.horizontal, 24)
    }
}
