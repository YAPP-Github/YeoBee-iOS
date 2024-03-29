//
//  TripCalculationView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/21/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

final class TripCalculationHostingController: UIHostingController<TripCalculationView> {
}


struct TripCalculationView: View {
    typealias State = TripCalculationReducer.State
    typealias Action = TripCalculationReducer.Action

    let store: StoreOf<TripCalculationReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            if viewStore.calculations.isEmpty {
                VStack(spacing: 30) {
                    Spacer()
                    DesignSystemAsset.Icons.emptyImage.swiftUIImage
                        .frame(width: 95, height: 84)
                    Text("홀로 여행을 하셨군요!\n정산할 내역이 없어요.")
                        .foregroundColor(.ybColor(.black))
                        .font(.ybfont(.body2))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView(showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 0) {
                                Text("\(viewStore.calculations.count)건")
                                    .foregroundColor(.ybColor(.mainGreen))
                                    .font(.ybfont(.header2))
                                Text("의 정산 내역")
                                    .foregroundColor(.ybColor(.gray6))
                                    .font(.ybfont(.header2))
                            }
                            Text("주고 받을 내역을 확인하세요.")
                                .foregroundColor(.ybColor(.gray5))
                                .font(.ybfont(.body3))
                        }
                        VStack(alignment: .leading, spacing: 18) {
                            ForEach(viewStore.calculations, id: \.self) {
                                TripCalculationItemView(calculation: $0)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(YBColor.gray1.swiftUIColor)
                })
            }
        }
        .onAppear { store.send(.onAppear) }
        .background(YBColor.gray1.swiftUIColor)
    }
}
