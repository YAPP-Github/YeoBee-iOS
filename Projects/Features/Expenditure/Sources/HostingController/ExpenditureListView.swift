//
//  ExpenditureListView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import UIKit
import ComposableArchitecture
import DesignSystem

final class ExpenditureListHostingController: UIHostingController<ExpenditureListView> {
}

struct ExpenditureListView: View {
    typealias State = ExpenditureListReducer.State
    typealias Action = ExpenditureListReducer.Action

    let store: StoreOf<ExpenditureListReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureListView {

    var containerView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                TotalPriceView(
                    store: store.scope(
                        state: \.totalPrice,
                        action: ExpenditureListReducer.Action.totalPrice
                    )
                )
                .padding(20)
            }
            .background(YBColor.white.swiftUIColor)
            .cornerRadius(10)
            .padding(18)
        }
        .background(YBColor.gray1.swiftUIColor)
    }
}
