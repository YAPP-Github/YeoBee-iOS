//
//  OnboardingView.swift
//  Onboarding
//
//  Created Hoyoung Lee on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem


final class OnboardingSheetHostingController: UIHostingController<OnboardingView> {
}

public enum OnboardingTab {
    case register, manage, calculate
}

struct OnboardingView: View {
    typealias State = OnboardingReducer.State
    typealias Action = OnboardingReducer.Action

    let store: StoreOf<OnboardingReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                TabView(selection: viewStore.$onboadingTab) {
                    registerView.tag(OnboardingTab.register)
                    manageView.tag(OnboardingTab.manage)
                    calculateView.tag(OnboardingTab.calculate)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                Button {
                    viewStore.send(.tappedNextButton(viewStore.onboadingTab))
                } label: {
                    Text(viewStore.buttonText)
                        .foregroundColor(.ybColor(.white))
                        .font(.ybfont(.title1))
                        .frame(height: 54)
                        .frame(maxWidth: .infinity)
                }
                .background(YBColor.black.swiftUIColor)
                .cornerRadius(10)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 4)
            }
            .background(YBColor.gray1.swiftUIColor)
        }
    }
}

extension OnboardingView {
    var registerView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("동행자 등록하기")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.header1))
                Text("여행 경비를 손쉽게 추적하세요\n최대 10명까지, 각자의 지출을 한눈에!")
                    .foregroundColor(.ybColor(.gray5))
                    .font(.ybfont(.body1))
                    .multilineTextAlignment(.center)
            }
            Spacer()
            DesignSystemAsset.Icons.travelBee.swiftUIImage
                .frame(width: 327, height: 219)
                .padding(.bottom, 40)
        }
        .padding(.top, 96)
        .background { YBColor.white.swiftUIColor }
        .cornerRadius(20)
        .padding(.horizontal, 24)
        .frame(height: 450)
    }

    var manageView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("개인&공동경비 관리하기")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.header1))
                Text("예산의 특징에 따라 나누어 관리해요\n실시간으로 잔고 내역을 한눈에!")
                    .foregroundColor(.ybColor(.gray5))
                    .font(.ybfont(.body1))
                    .multilineTextAlignment(.center)
            }
            Spacer()
            DesignSystemAsset.Icons.honeyBee.swiftUIImage
                .frame(width: 327, height: 199)
                .padding(.bottom, 40)
        }
        .padding(.top, 96)
        .background { YBColor.white.swiftUIColor }
        .cornerRadius(20)
        .padding(.horizontal, 24)
        .frame(height: 450)
    }

    var calculateView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("여행경비 정산하기")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.header1))
                Text("간편하게 정산된 금액만 확인해요\n여행의 마지막은 깔끔한 정산!")
                    .foregroundColor(.ybColor(.gray5))
                    .font(.ybfont(.body1))
                    .multilineTextAlignment(.center)
            }
            Spacer()
            DesignSystemAsset.Icons.calculateBee.swiftUIImage
                .frame(width: 327, height: 183)
                .padding(.bottom, 40)
        }
        .padding(.top, 96)
        .background { YBColor.white.swiftUIColor }
        .cornerRadius(20)
        .padding(.horizontal, 24)
        .frame(height: 450)
    }
}
