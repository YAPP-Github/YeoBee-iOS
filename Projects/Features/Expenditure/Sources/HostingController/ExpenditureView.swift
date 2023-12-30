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

final class ExpenditureHostingController: UIHostingController<ExpenditureView> {
}

struct ExpenditureView: View {
    typealias State = ExpenditureReducer.State
    typealias Action = ExpenditureReducer.Action

    let store: StoreOf<ExpenditureReducer>

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    containerView
                }
                .background(YBColor.white.swiftUIColor)
                .cornerRadius(10)
                .padding(18)
                .frame(minHeight: proxy.frame(in: .global).height)
            }
            .background(YBColor.gray1.swiftUIColor)
        }
    }
}

extension ExpenditureView {

    var containerView: some View {
        VStack(spacing: 0) {
            TotalPriceView(
                store: store.scope(
                    state: \.totalPrice,
                    action: ExpenditureReducer.Action.totalPrice
                )
            )
            .padding(.bottom, 16)
            TripDateView(
                store: store.scope(
                    state: \.tripDate,
                    action: ExpenditureReducer.Action.tripDate
                )
            )
            .padding(.bottom, 26)
            ExpenditureListView(
                store: store.scope(
                    state: \.expenditureList,
                    action: ExpenditureReducer.Action.expenditureList
                )
            )
        }
        .padding(20)
    }
}
