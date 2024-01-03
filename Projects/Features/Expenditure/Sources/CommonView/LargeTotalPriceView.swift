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
    let price: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.ybColor(.gray5))
                .font(.ybfont(.body3))

            Text(price)
                .foregroundColor(.ybColor(.black))
                .font(.ybfont(.header1))
        }
    }
}
