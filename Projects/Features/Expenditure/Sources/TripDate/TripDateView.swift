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
            TripReadyView {
                store.send(.tappedTripReadyButton)
            }
            tripDatesView
        }
    }


    var tripDatesView: some View {
        WithViewStore(store, observe: \.selectedDate) { viewStore in
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
                }
                .padding(.leading, 6)
                .onChange(of: viewStore.state, perform: { newValue in
                    withAnimation {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                })
            }
        }
    }
}
