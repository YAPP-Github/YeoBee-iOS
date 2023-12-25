//
//  YBFont.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/21.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

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
}

extension UIFont {
    static func ybfont(_ ybfont: YBFont) -> UIFont {
        return ybfont.font
    }
}
