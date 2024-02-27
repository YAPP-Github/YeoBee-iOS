//
//  TripDateView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture

struct TripDateView: View {
    typealias State = TripDateReducer.State
    typealias Action = TripDateReducer.Action

    let store: StoreOf<TripDateReducer>

    var body: some View {
        HStack(spacing: 10) {
            tripDatesView
        }
    }

    var tripDatesView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 26) {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEachStore(
                                store.scope(
                                    state: \.tripDateItems,
                                    action: TripDateReducer.Action.tripDateItem)
                            ) { store in
                                TripDateItemView(store: store)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                    .onChange(of: viewStore.selectedDate, perform: { newValue in
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    })
                }
                TabView(selection: viewStore[keyPath: \.$selectedDate]) {
                    ForEachStore(
                        store.scope(
                            state: \.expenditureListStates,
                            action: TripDateReducer.Action.expenditureList)
                    ) { store in
                        store.withState { state in
                            ExpenditureListView(store: store)
                                .padding(.horizontal, 20)
                                .tag(state.date)
                        }
                    }
                }
            }
        }
    }
}
