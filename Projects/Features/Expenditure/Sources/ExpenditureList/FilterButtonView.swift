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
    let action: () -> Void

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        HStack {
            Button {
                action()
            } label: {
                HStack(spacing: 6) {
                    Text(title)
                        .foregroundColor(.ybColor(.gray5))
                        .font(.ybfont(.body3))
                    DesignSystemAsset.Icons.dropdown.swiftUIImage
                        .frame(width: 3, height: 7)
                }
            }
            Spacer()
        }
    }
}
