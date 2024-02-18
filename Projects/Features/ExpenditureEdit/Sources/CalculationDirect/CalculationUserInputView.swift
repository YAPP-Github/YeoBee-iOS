//
//  CalculationUserInputView.swift
//  ExpenditureEdit
//
//  Created Hoyoung Lee on 2/18/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct CalculationUserInputView: View {
    typealias State = CalculationUserInputReducer.State
    typealias Action = CalculationUserInputReducer.Action

    let store: StoreOf<CalculationUserInputReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
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
                CalculatuionInputView(text: viewStore[keyPath: \.$text], placeholder: "직접입력 (KRW)") {
                    let toast = Toast.text(icon: .complete, "최대 10자까지 입력 가능해요.")
                    toast.show()
                }
                .frame(width: 150)
            }
        }
    }
}
