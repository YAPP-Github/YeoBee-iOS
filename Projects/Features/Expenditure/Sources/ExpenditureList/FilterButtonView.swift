//
//  FilterButtonView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FilterButtonView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.ybColor(.gray5))
                .font(.ybfont(.body3))
            // TODO: icon
        }
    }
}
