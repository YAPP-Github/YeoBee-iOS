//
//  LargeTotalPriceView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import SwiftUI
import DesignSystem

struct LargeTotalPriceView: View {
    let title: String
    let price: Int
    let isTappable: Bool
    let action: () -> Void

    init(
        title: String,
        price: Int,
        isTappable: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.price = price
        self.isTappable = isTappable
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Text(title)
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body3))
                    if isTappable {
                        DesignSystemAsset.Icons.next.swiftUIImage
                            .frame(width: 4, height: 8)
                    }
                }
                Text(price.formattedWithSeparator + "원")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.header1))
                    .padding(.bottom, 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .disabled(true)
    }
}
