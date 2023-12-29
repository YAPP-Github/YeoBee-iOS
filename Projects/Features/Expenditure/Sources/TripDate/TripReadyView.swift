//
//  TripReadyView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import SwiftUI
import DesignSystem

struct TripReadyView: View {

    let tappedAction: () -> Void

    init(tappedAction: @escaping () -> Void) {
        self.tappedAction = tappedAction
    }

    var body: some View {
        Button {
            tappedAction()
        } label: {
            VStack(spacing: 2) {
                Text("준비")
                    .foregroundColor(.ybColor(.gray6))
                    .font(.ybfont(.body3))
                    .frame(height: 21)
                DesignSystemAsset.Icons.airplane.swiftUIImage
                    .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 53)
        }
        .buttonStyle(.plain)
    }
}
