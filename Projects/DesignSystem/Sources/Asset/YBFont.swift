//
//  YBFont.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/21.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public enum YBFont {
    case header1
    case header2
    case title1
    case body1
    case body2
    case body3
    case body4
}

extension YBFont {
    public var font: UIFont {
        switch self {
        case .header1:
            return .init(
                font: DesignSystemFontFamily.Pretendard.bold, size: 22
            ) ?? .systemFont(ofSize: 22, weight: .bold)
        case .header2:
            return .init(
                font: DesignSystemFontFamily.Pretendard.bold, size: 20
            ) ?? .systemFont(ofSize: 20, weight: .bold)
        case .title1:
            return .init(
                font: DesignSystemFontFamily.Pretendard.bold, size: 17
            ) ?? .systemFont(ofSize: 17, weight: .bold)
        case .body1:
            return .init(
                font: DesignSystemFontFamily.Pretendard.bold, size: 16
            ) ?? .systemFont(ofSize: 16, weight: .bold)
        case .body2:
            return .init(
                font: DesignSystemFontFamily.Pretendard.bold, size: 15
            ) ?? .systemFont(ofSize: 15, weight: .bold)
        case .body3:
            return .init(
                font: DesignSystemFontFamily.Pretendard.semiBold, size: 14
            ) ?? .systemFont(ofSize: 14, weight: .semibold)
        case .body4:
            return .init(
                font: DesignSystemFontFamily.Pretendard.medium, size: 13
            ) ?? .systemFont(ofSize: 13, weight: .medium)
        }
    }

    public var swiftUIfont: Font {
        switch self {
        case .header1: return .custom(DesignSystemFontFamily.Pretendard.bold.name, size: 22)
        case .header2: return .custom(DesignSystemFontFamily.Pretendard.bold.name, size: 20)
        case .title1: return .custom(DesignSystemFontFamily.Pretendard.bold.name, size: 17)
        case .body1: return .custom(DesignSystemFontFamily.Pretendard.bold.name, size: 16)
        case .body2: return .custom(DesignSystemFontFamily.Pretendard.bold.name, size: 15)
        case .body3: return .custom(DesignSystemFontFamily.Pretendard.semiBold.name, size: 14)
        case .body4: return .custom(DesignSystemFontFamily.Pretendard.medium.name, size: 20)
        }
    }
}

extension UIFont {
    public static func ybfont(_ ybfont: YBFont) -> UIFont {
        return ybfont.font
    }
}

extension Font {
    public static func ybfont(_ ybfont: YBFont) -> Font {
        return ybfont.swiftUIfont
    }
}
