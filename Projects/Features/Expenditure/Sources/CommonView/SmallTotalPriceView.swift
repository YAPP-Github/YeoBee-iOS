//
//  SmallTotalPriceView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import SwiftUI
import DesignSystem

struct SmallTotalPriceView: View {
    let title: String
    let price: Int
    let titleColor: YBColor

    init(title: String, titleColor: YBColor = .gray4, price: Int) {
        self.title = title
        self.price = price
        self.titleColor = titleColor
    }

    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .foregroundColor(titleColor.swiftUIColor)
                .font(.ybfont(.body3))
            Spacer()
            HStack(spacing: 0) {
                Text(price.formattedWithSeparator)
                    .foregroundColor(.ybColor(.gray6))
                    .font(.ybfont(.body3))
                    .lineLimit(1)
                Text("원")
                    .foregroundColor(.ybColor(.gray6))
                    .font(.ybfont(.body3))
            }
        }
    }
}
