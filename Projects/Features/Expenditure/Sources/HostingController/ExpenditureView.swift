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
            ZStack(alignment: .bottom) {
                ScrollView(showsIndicators: false) {
                    VStack {
                        containerView
                    }
                    .background(YBColor.white.swiftUIColor)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 18)
                    .frame(minHeight: proxy.frame(in: .global).height)
                }
                .background(YBColor.gray1.swiftUIColor)
                addButtonView
            }
        }
        .onAppear { store.send(.onAppear) }
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
            YBDividerView()
                .padding(.vertical, 16)
            TripDateView(
                store: store.scope(
                    state: \.tripDate,
                    action: ExpenditureReducer.Action.tripDate
                )
            )
            .padding(.bottom, 26)
            FilterButtonView(title: "전체내역") {
                store.send(.tappedFilterButton)
            }
            .padding(.bottom, 20)
            ExpenditureListView(
                store: store.scope(
                    state: \.expenditureList,
                    action: ExpenditureReducer.Action.expenditureList
                )
            )
            .padding(.bottom, -20)
        }
        .padding(20)
    }

    var addButtonView: some View {
        Button {
            store.send(.tappedAddButton)
        } label: {
            Text("추가")
                .foregroundColor(.ybColor(.white))
                .font(.ybfont(.header2))
                .frame(width: 100, height: 50)
        }
        .background(YBColor.gray6.swiftUIColor)
        .cornerRadius(30)
        .padding(.bottom, 33)
    }
}
