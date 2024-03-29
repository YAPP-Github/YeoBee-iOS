//
//  ExpenseCalculationButtonView.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import SwiftUI
import DesignSystem

struct ExpenseCalculationButtonView: View {

    let text: String
    let action: () -> Void

    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }

    var body: some View {
        HStack {
            HStack(spacing: 0) {
                Text("정산방법")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.title1))
                Text("*")
                    .foregroundColor(.ybColor(.mainGreen))
                    .font(.ybfont(.body3))
            }
            Spacer()
            Button {
                action()
            } label: {
                HStack(spacing: 0) {
                    Text(text)
                        .foregroundColor(.ybColor(.gray5))
                        .font(.ybfont(.body1))
                    DesignSystemAsset.Icons.next.swiftUIImage
                        .frame(width: 24, height: 24)
                        .foregroundColor(.ybColor(.gray4))
                }
            }
        }
    }
}
