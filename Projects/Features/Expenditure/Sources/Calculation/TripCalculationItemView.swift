//
//  TripCalculationItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/21/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Entity
import Kingfisher

struct TripCalculationItemView: View {

    let calculation: Calculation
    init(calculation: Calculation) {
        self.calculation = calculation
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                Text(calculation.sender.name)
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.body1))
                Text("의 보낼돈")
                    .foregroundColor(.ybColor(.gray6))
                    .font(.ybfont(.body2))
            }
            YBDividerView()
            HStack(spacing: 12) {
                if let profileImageUrl = calculation.receiver.profileImageURL {
                    KFImage(URL(string: profileImageUrl))
                        .resizable()
                        .frame(width: 30, height: 30)
                } else {
                    DesignSystemAsset.Icons.face0.swiftUIImage
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                HStack(spacing: 0) {
                    Text(calculation.receiver.name)
                        .foregroundColor(.ybColor(.black))
                        .font(.ybfont(.body1))
                    Text(" 에게")
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body2))
                }
                Spacer()
                Text(calculation.koreanAmount.formattedWithSeparator + "원")
                    .foregroundColor(.ybColor(.gray6))
                    .font(.ybfont(.body1))
            }
        }
        .padding(20)
        .background(YBColor.white.swiftUIColor)
        .cornerRadius(10)
    }
}
