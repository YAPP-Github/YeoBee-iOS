//
//  TripDateItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct TripDateItemView: View {
    typealias State = TripDateItemReducer.State
    typealias Action = TripDateItemReducer.Action

    let store: StoreOf<TripDateItemReducer>

    var body: some View {
        Button {
            store.send(.tappedItem)
        } label: {
            containerView
        }
        .buttonStyle(.plain)
    }
}

extension TripDateItemView {
    var containerView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 2) {
                Text(viewStore.week)
                    .foregroundColor(.ybColor(.gray6))
                    .font(.ybfont(.body3))
                    .frame(height: 21)
                ZStack {
                    if viewStore.isSelected {
                        Circle()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.ybColor(.mainGreen))
                    }
                    Text("\(viewStore.day)")
                        .foregroundColor(viewStore.isSelected ? .ybColor(.white) : .ybColor(.gray6))
                        .font(.ybfont(.body1))
                }
                .frame(width: 30, height: 30)
            }
            .frame(width: 30, height: 53)
            .id(viewStore.date)
        }
    }
}
