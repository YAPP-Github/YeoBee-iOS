//
//  TotalPriceToggleView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import SwiftUI
import DesignSystem

struct TotalPriceToggleView: View {
    @Binding var totalPriceTab: TotalPriceTab

    init(totalPriceTab: Binding<TotalPriceTab>) {
        self._totalPriceTab = totalPriceTab
    }
    var body: some View {
        GeometryReader { reader in
            ZStack {
                HStack(spacing: 0) {
                    if totalPriceTab == .expense {
                        Spacer(minLength: 0)
                    }
                    VStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(10)
                    }
                    .frame(width: reader.frame(in: .global).width / 2)
                    .padding(4)
                    if totalPriceTab == .budget {
                        Spacer(minLength: 0)
                    }
                }
                .animation(.spring, value: totalPriceTab)
                HStack(spacing: 0) {
                    Button {
                        withAnimation {
                            totalPriceTab.toggle()
                        }
                    } label: {
                        Text("총예산")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body3))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Button {
                        withAnimation {
                            totalPriceTab.toggle()
                        }
                    } label: {
                        Text("총쓴돈")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body3))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .background(YBColor.gray2.swiftUIColor)
            .cornerRadius(10)
        }
    }
}

extension TotalPriceTab {
    mutating func toggle() {
        switch self {
        case .budget:
            self = .expense
        case .expense:
            self = .budget
        }
    }
}
