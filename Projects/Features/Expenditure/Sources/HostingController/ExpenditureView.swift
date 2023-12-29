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


public extension View {
    func debug(_ color: Color = .blue) -> some View {
        modifier(FrameInfo(color: color))
    }
}

private struct FrameInfo: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
        #if DEBUG
            .overlay(GeometryReader(content: overlay))
        #endif
    }

    func overlay(for geometry: GeometryProxy) -> some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .strokeBorder(style: .init(lineWidth: 1, dash: [3]))
                .foregroundColor(color)

            Text("(\(Int(geometry.frame(in: .global).origin.x)), \(Int(geometry.frame(in: .global).origin.y))) \(Int(geometry.size.width))x\(Int(geometry.size.height))")
                .font(.caption2)
                .minimumScaleFactor(0.5)
                .foregroundColor(color)
                .padding(3)
                .offset(y: -20)
        }
    }
}
