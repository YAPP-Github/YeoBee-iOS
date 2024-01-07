//
//  ExpenditureCategoryItemView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct ExpenditureCategoryItemView: View {
    typealias State = ExpenditureCategoryItemReducer.State
    typealias Action = ExpenditureCategoryItemReducer.Action

    let store: StoreOf<ExpenditureCategoryItemReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureCategoryItemView {
    var containerView: some View {
        WithViewStore(store, observe: \.category) { viewStore in
            Button(action: {
                viewStore.send(.tappedCategory)
            }, label: {
                VStack(alignment: .center) {
                    viewStore.state.image
                        .resizable()
                        .frame(width: 41, height: 41)
                    Text(viewStore.state.text)
                        .foregroundColor(.ybColor(.gray4))
                        .font(.ybfont(.body2))
                }
            })
        }
    }
}

extension Category {
    var text: String {
        switch self {
        case .activity: return "액티비티"
        case .air: return "항공"
        case .eating: return "식비"
        case .shopping: return "쇼핑"
        case .stay: return "숙박"
        case .transition: return "교통"
        case .travel: return "관광"
        case .etc: return "기타"
        }
    }

    var image: Image {
        switch self {
        case .activity: return DesignSystemAsset.Icons.activity.swiftUIImage
        case .air: return DesignSystemAsset.Icons.air.swiftUIImage
        case .eating: return DesignSystemAsset.Icons.eating.swiftUIImage
        case .etc: return DesignSystemAsset.Icons.etc.swiftUIImage
        case .shopping: return DesignSystemAsset.Icons.shopping.swiftUIImage
        case .stay: return DesignSystemAsset.Icons.stay.swiftUIImage
        case .transition: return DesignSystemAsset.Icons.transition.swiftUIImage
        case .travel: return DesignSystemAsset.Icons.travel.swiftUIImage
        }
    }
}
