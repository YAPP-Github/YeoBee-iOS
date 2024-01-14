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

public enum ExpendCategory {
    case transition, eating, stay, travel, activity, shopping, air, etc
}

extension ExpendCategory {
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