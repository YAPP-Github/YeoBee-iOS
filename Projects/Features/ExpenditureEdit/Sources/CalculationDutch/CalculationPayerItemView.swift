//
//  CalculationPayerItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct CalculationPayerItemView: View {
    typealias State = CalculationPayerItemReducer.State
    typealias Action = CalculationPayerItemReducer.Action

    let store: StoreOf<CalculationPayerItemReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Button(action: {
                viewStore.send(.tappedPayrtItem(viewStore.user))
            }, label: {
                HStack(spacing: 12) {
                    if let profileImageUrl = viewStore.user.profileImageUrl {
                        AsyncImage(url: URL(string: profileImageUrl), scale: 15)
                            .frame(width: 44, height: 44)
                    } else {
                        DesignSystemAsset.Icons.face0.swiftUIImage
                            .resizable()
                            .frame(width: 44, height: 44)
                    }
                    Text(viewStore.user.name ?? "")
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body2))
                    Spacer()
                    if viewStore.isChecked {
                        DesignSystemAsset.Icons.check.swiftUIImage
                            .frame(width: 28, height: 28)
                    } else {
                        DesignSystemAsset.Icons.uncheck.swiftUIImage
                            .frame(width: 28, height: 28)
                    }
                }
            })
        }
    }
}
