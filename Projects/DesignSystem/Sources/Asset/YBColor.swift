//
//  YBColor.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/24.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

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
        }
    }
}

extension UIColor {
    static func ybColor(_ ybColor: YBColor) -> UIColor {
        return ybColor.color
    }
}
