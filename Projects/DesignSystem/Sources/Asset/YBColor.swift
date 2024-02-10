//
//  YBColor.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/24.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public enum YBColor: Equatable, Hashable {
    case black
    case brightGreen
    case brightRed
    case gray1
    case gray2
    case gray3
    case gray4
    case gray5
    case gray6
    case mainGreen
    case mainRed
    case mediumGreen
    case white
    case kakaoYellow
}

public extension YBColor {
    var color: UIColor {
        switch self {
        case .black: return DesignSystemAsset.Colors.black.color
        case .brightGreen: return DesignSystemAsset.Colors.brightGreen.color
        case .brightRed: return DesignSystemAsset.Colors.brightRed.color
        case .gray1: return DesignSystemAsset.Colors.gray1.color
        case .gray2: return DesignSystemAsset.Colors.gray2.color
        case .gray3: return DesignSystemAsset.Colors.gray3.color
        case .gray4: return DesignSystemAsset.Colors.gray4.color
        case .gray5: return DesignSystemAsset.Colors.gray5.color
        case .gray6: return DesignSystemAsset.Colors.gray6.color
        case .mainGreen: return DesignSystemAsset.Colors.maingreen.color
        case .mainRed: return DesignSystemAsset.Colors.mainRed.color
        case .mediumGreen: return DesignSystemAsset.Colors.mediumGreen.color
        case .white: return DesignSystemAsset.Colors.white.color
        case .kakaoYellow: return DesignSystemAsset.Colors.kakaoYellow.color
        }
    }

    var swiftUIColor: Color {
        switch self {
        case .black: return DesignSystemAsset.Colors.black.swiftUIColor
        case .brightGreen: return DesignSystemAsset.Colors.brightGreen.swiftUIColor
        case .brightRed: return DesignSystemAsset.Colors.brightRed.swiftUIColor
        case .gray1: return DesignSystemAsset.Colors.gray1.swiftUIColor
        case .gray2: return DesignSystemAsset.Colors.gray2.swiftUIColor
        case .gray3: return DesignSystemAsset.Colors.gray3.swiftUIColor
        case .gray4: return DesignSystemAsset.Colors.gray4.swiftUIColor
        case .gray5: return DesignSystemAsset.Colors.gray5.swiftUIColor
        case .gray6: return DesignSystemAsset.Colors.gray6.swiftUIColor
        case .mainGreen: return DesignSystemAsset.Colors.maingreen.swiftUIColor
        case .mainRed: return DesignSystemAsset.Colors.mainRed.swiftUIColor
        case .mediumGreen: return DesignSystemAsset.Colors.mediumGreen.swiftUIColor
        case .white: return DesignSystemAsset.Colors.white.swiftUIColor
        case .kakaoYellow: return DesignSystemAsset.Colors.kakaoYellow.swiftUIColor
        }
    }
}

extension UIColor {
    public static func ybColor(_ ybColor: YBColor) -> UIColor {
        return ybColor.color
    }
}

extension Color {
    public static func ybColor(_ ybColor: YBColor) -> Color {
        return ybColor.swiftUIColor
    }
}
