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

struct HeightPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

extension View {
    func installHeight() -> some View {
        self
            .background {
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                }
            }
    }
}

struct PaginationScrollView<Content: View>: View {
    var onPagination: () -> Void
    @ViewBuilder var content: Content
    var body: some View {
        GeometryReader { containerGeometry in
            ScrollView {
                content
                    .background(alignment: .bottom) {
                        GeometryReader { geometry in
                            let maxY = geometry.frame(in: .named("ScrollView")).maxY
                            let height = containerGeometry.size.height
                            Color.clear
                                .onChange(of: maxY <= height) { newValue in
                                    if newValue {
                                        onPagination()
                                    }
                                }
                        }
                    }

            }
            .coordinateSpace(name: "ScrollView")
        }
    }
}

struct ExpenditureView: View {
    typealias State = ExpenditureReducer.State
    typealias Action = ExpenditureReducer.Action

    let store: StoreOf<ExpenditureReducer>

    @SwiftUI.State private var heightSum: CGFloat = 0.0

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                PaginationScrollView(onPagination: {
                    store.send(.appendExpenditures)
                }, content: {
                    LazyVStack {
                        TotalPriceView(
                            store: store.scope(
                                state: \.totalPrice,
                                action: ExpenditureReducer.Action.totalPrice
                            )
                        )
                        .installHeight()
                        YBDividerView()
                            .padding(.bottom, 12)
                            .installHeight()
                        TripDateView(
                            store: store.scope(
                                state: \.tripDate,
                                action: ExpenditureReducer.Action.tripDate
                            )
                        )
                        .padding(.bottom, 26)
                        .installHeight()
                        WithViewStore(store, observe: \.currentFilter) { viewStore in
                            FilterButtonView(title: viewStore.state?.rawValue ?? "전체보기") {
                                store.send(.tappedFilterButton(viewStore.state))
                            }
                            .padding(.bottom, 20)
                        }
                        .installHeight()
                        ExpenditureListView(
                            store: store.scope(
                                state: \.expenditureList,
                                action: ExpenditureReducer.Action.expenditureList
                            )
                        )
                        .frame(minHeight: proxy.size.height - heightSum - 80)
                    }
                    .padding(20)
                    .background(YBColor.white.swiftUIColor)
                    .cornerRadius(10)
                    .padding(.top, 10)
                    .padding(.horizontal, 18)
                    .padding(.bottom, 18)
                    .frame(minHeight: proxy.size.height)
                })
                .background(YBColor.gray1.swiftUIColor)
                addButtonView
            }
            .onPreferenceChange(HeightPreferenceKey.self, perform: { height in
                if heightSum == 0.0 {
                    heightSum = height
                }
            })
        }
        .onAppear { store.send(.onAppear) }
    }
}

extension ExpenditureView {

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
        .padding(.bottom, 30)
    }
}
