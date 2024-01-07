//
//  ExpenditureToggleView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import DesignSystem

struct ExpenditureToggleView: View {
    @Binding var expenditureTab: ExpenditureTab

    init(expenditureTab: Binding<ExpenditureTab>) {
        self._expenditureTab = expenditureTab
    }
    var body: some View {
        GeometryReader { reader in
            ZStack {
                HStack(spacing: 0) {
                    if expenditureTab == .individual {
                        Spacer(minLength: 0)
                    }
                    VStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(10)
                    }
                    .frame(width: reader.frame(in: .global).width / 2)
                    .padding(4)
                    if expenditureTab == .shared {
                        Spacer(minLength: 0)
                    }
                }
                .animation(.default, value: expenditureTab)
                HStack(spacing: 0) {
                    Button {
                        withAnimation {
                            expenditureTab.toggle()
                        }
                    } label: {
                        Text("공동")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body3))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Button {
                        withAnimation {
                            expenditureTab.toggle()
                        }
                    } label: {
                        Text("개인")
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

extension ExpenditureTab {
    mutating func toggle() {
        switch self {
        case .shared:
            self = .individual
        case .individual:
            self = .shared
        }
    }
}
