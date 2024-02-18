//
//  ExpenditureCalculationView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import Entity
import DesignSystem

final class CalculationHostingController: UIHostingController<ExpenditureCalculationView> {
}


struct ExpenditureCalculationView: View {
    typealias State = ExpenditureCalculationReducer.State
    typealias Action = ExpenditureCalculationReducer.Action

    let store: StoreOf<ExpenditureCalculationReducer>

    var body: some View {
        containerView
//            .onAppear { store.send(.onAppear) }
    }
}

extension ExpenditureCalculationView {

    @MainActor
    var containerView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                Text("어떻게 정산 하시나요?")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.header2))
                CalculationToggleView(
                    calculationType: viewStore.$seletedCalculationType
                )
                .frame(height: 40)
                .padding(.top, 16)
                .padding(.bottom, 22)
                TabView(selection: viewStore.$seletedCalculationType) {
                    ExpenditureCalculationDutchView(
                        store: store.scope(
                            state: \.dutch,
                            action: ExpenditureCalculationReducer.Action.dutch
                        )
                    )
                    .tag(CalculationType.dutch)
                    ExpenditureCalculationDirectView(
                        store: store.scope(
                            state: \.direct,
                            action: ExpenditureCalculationReducer.Action.direct
                        )
                    )
                    .tag(CalculationType.direct)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .padding(.horizontal, 24)
            .padding(.top, 22)
            .background(YBColor.gray1.swiftUIColor, ignoresSafeAreaEdges: [.all])
        }
    }
}

struct CalculationToggleView: View {
    @Binding var calculationType: CalculationType

    init(calculationType: Binding<CalculationType>) {
        self._calculationType = calculationType
    }
    var body: some View {
        GeometryReader { reader in
            ZStack {
                HStack(spacing: 0) {
                    if calculationType == .direct {
                        Spacer(minLength: 0)
                    }
                    VStack {
                        Rectangle()
                            .fill(Color.white)
                            .cornerRadius(10)
                    }
                    .frame(width: reader.frame(in: .global).width / 2)
                    .padding(4)
                    if calculationType == .dutch {
                        Spacer(minLength: 0)
                    }
                }
                .animation(.default, value: calculationType)
                HStack(spacing: 0) {
                    Button {
                        withAnimation {
                            calculationType.toggle()
                        }
                    } label: {
                        Text("1/N 정산")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body3))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Button {
                        withAnimation {
                            calculationType.toggle()
                        }
                    } label: {
                        Text("직접정산")
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

extension CalculationType {
    mutating func toggle() {
        switch self {
        case .direct:
            self = .dutch
        case .dutch:
            self = .direct
        }
    }
}

