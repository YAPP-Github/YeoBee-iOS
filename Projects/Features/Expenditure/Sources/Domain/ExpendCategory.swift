//
//  ExpendCategory.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 1/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import SwiftUI
import DesignSystem
import Entity

extension ExpendCategory {
    var image: Image {
        switch self {
        case .activity: return DesignSystemAsset.Icons.activity.swiftUIImage
        case .flight: return DesignSystemAsset.Icons.air.swiftUIImage
        case .food: return DesignSystemAsset.Icons.eating.swiftUIImage
        case .etc: return DesignSystemAsset.Icons.etc.swiftUIImage
        case .shopping: return DesignSystemAsset.Icons.shopping.swiftUIImage
        case .lodge: return DesignSystemAsset.Icons.stay.swiftUIImage
        case .transport: return DesignSystemAsset.Icons.transition.swiftUIImage
        case .travel: return DesignSystemAsset.Icons.travel.swiftUIImage
        case .income: return DesignSystemAsset.Icons.income.swiftUIImage
        }
    }

    var text: String {
        switch self {
        case .activity: return "액티비티"
        case .flight: return "항공"
        case .food: return "식비"
        case .shopping: return "쇼핑"
        case .lodge: return "숙박"
        case .transport: return "교통"
        case .travel: return "관광"
        case .etc: return "기타"
        case .income: return "수입"
        }
    }
}
