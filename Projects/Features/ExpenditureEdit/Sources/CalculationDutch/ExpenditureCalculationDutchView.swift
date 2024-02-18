//
//  ExpenditureCalculationDutchView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureCalculationDutchView: View {
    typealias State = ExpenditureCalculationDutchReducer.State
    typealias Action = ExpenditureCalculationDutchReducer.Action

    let store: StoreOf<ExpenditureCalculationDutchReducer>

    var body: some View {
        ZStack {
            WithViewStore(store, observe: \.isEnableRegisterButton) { viewStore in
                ScrollView(showsIndicators: false) {
                    VStack {
                        contentView
                        Button {
                            viewStore.send(.tappedConfirmButton)
                        } label: {
                            Text("확인")
                                .foregroundColor(viewStore.state ? .ybColor(.white) : .ybColor(.gray5))
                                .font(.ybfont(.title1))
                                .frame(height: 54)
                                .frame(maxWidth: .infinity)
                        }
                        .background(viewStore.state ? YBColor.black.swiftUIColor : YBColor.gray3.swiftUIColor)
                        .cornerRadius(10)
                        .padding(.top, 16)
                        .padding(.bottom, 4)
                        .background(YBColor.gray1.swiftUIColor)
                    }
                }
            }
        }
    }
}

extension ExpenditureCalculationDutchView {
    var contentView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(viewStore.expenseDetail.currency)
                        .foregroundColor(.ybColor(.gray4))
                        .font(.ybfont(.body2))
                    Text(viewStore.expenseDetail.amount.formattedWithSeparator)
                        .foregroundColor(.ybColor(.gray5))
                        .font(.ybfont(.header1))
                }
                .padding(.bottom, 30)
                YBDividerView()
                    .padding(.bottom, 20)
                VStack(alignment: .leading, spacing: 20) {
                    Text("결제자")
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body2))
                    ForEachStore(
                        store.scope(
                            state: \.payerListItems,
                            action: ExpenditureCalculationDutchReducer.Action.payerItem
                        )
                    ) { store in
                        CalculationPayerItemView(store: store)
                    }
                }
                .padding(.bottom, 20)
                WithViewStore(store, observe: { $0 }) { viewStore in
                    VStack(alignment: .leading, spacing: 20) {
                        Text("돈 낼 사람")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body2))
                        ForEach(viewStore.tripItem.tripUserList) { tripUser in
                            HStack(spacing: 12) {
                                if let profileImageUrl = tripUser.profileImageUrl {
                                    AsyncImage(url: URL(string: profileImageUrl), scale: 15)
                                        .frame(width: 44, height: 44)
                                } else {
                                    DesignSystemAsset.Icons.face0.swiftUIImage
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                }
                                Text(tripUser.name ?? "")
                                    .foregroundColor(.ybColor(.gray6))
                                    .font(.ybfont(.body2))
                                Spacer()
                                Text(viewStore.dutchAmount.formattedWithSeparator)
                                    .foregroundColor(.ybColor(.gray6))
                                    .font(.ybfont(.body2))
                            }
                        }
                    }
                }
            }
            .padding(20)
            .background(YBColor.white.swiftUIColor)
            .cornerRadius(10)
        }
    }
}
