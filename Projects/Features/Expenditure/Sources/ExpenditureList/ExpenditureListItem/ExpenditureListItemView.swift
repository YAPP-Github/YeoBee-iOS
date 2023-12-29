//
//  ExpenditureListItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureListItemView: View {
    typealias State = ExpenditureListItemReducer.State
    typealias Action = ExpenditureListItemReducer.Action

    let store: StoreOf<ExpenditureListItemReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureListItemView {
    var containerView: some View {
        HStack(alignment: .top, spacing: 12) {
            DesignSystemAsset.Icons.activity.swiftUIImage
                .frame(width: 41, height: 41)
            VStack(alignment: .trailing, spacing: 4) {
                HStack(alignment: .top, spacing: 9) {
                    Text("최대8자리까지만")
                        .foregroundColor(.ybColor(.black))
                        .font(.ybfont(.body2))
                        .lineLimit(1)
                    Spacer(minLength: 0)
                    Text("-10000000.00")
                        .foregroundColor(.ybColor(.black))
                        .font(.ybfont(.body2))
                        .lineLimit(1)
                }
                Text("143,221,954,567원")
                    .foregroundColor(.ybColor(.gray5))
                    .font(.ybfont(.body3))
                    .lineLimit(1)
            }
            .padding(.top, 5)

        }
    }
}
