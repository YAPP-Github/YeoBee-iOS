//
//  ExpenditureToggleView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import DesignSystem
import Entity

struct ExpenditureToggleView: View {
    @Binding var expenditureTab: ExpenditureType
    let isSharedTrip: Bool

    init(expenditureTab: Binding<ExpenditureType>, isSharedTrip: Bool) {
        self._expenditureTab = expenditureTab
        self.isSharedTrip = isSharedTrip
    }
    var body: some View {
        GeometryReader { reader in
            ZStack {
                HStack(spacing: 0) {
                    if expenditureTab == .budget {
                        Spacer(minLength: 0)
                    }
                    VStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(10)
                    }
                    .frame(width: reader.frame(in: .global).width / 2)
                    .padding(4)
                    if expenditureTab == .expense {
                        Spacer(minLength: 0)
                    }
                }
                .animation(.spring, value: expenditureTab)
                HStack(spacing: 0) {
                    Button {
                        withAnimation {
                            expenditureTab.toggle()
                        }
                    } label: {
                        Text("지출 추가")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body3))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Button {
                        withAnimation {
                            expenditureTab.toggle()
                        }
                    } label: {
                        Text(isSharedTrip ? "공동경비 추가" : "내예산 추가")
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

extension ExpenditureType {
    mutating func toggle() {
        switch self {
        case .budget:
            self = .expense
        case .expense:
            self = .budget
        }
    }
}
