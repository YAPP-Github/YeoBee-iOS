//
//  YBTextButton.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBTextButton: UIButton {
    
    public init(text: String, appearance: Appearance, size: Size) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        setTitle(text, for: .normal)
        
        configuration = configureConfiguration(appearance: appearance, size: size)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension YBTextButton {
    
    func configureConfiguration(appearance: Appearance, size: Size) -> Configuration {
        var configuration: UIButton.Configuration = .filled()
        configuration.baseBackgroundColor = appearance.backgroundColor.color
        configuration.baseForegroundColor = appearance.textColor.color
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer (
            { incoming in
                var outgoing = incoming
                outgoing.font = size.font.font
                return outgoing
            }
        )
        configuration.background.cornerRadius = size.cornerRadius
        configuration.background.strokeWidth = 1.0
        return configuration
    }
}

public extension YBTextButton {
    enum Appearance {
        case `default`
        case defaultDisable
        case select
        case selectDisable
    }
    
    enum Size {
        case large
        case medium
        case small
    }
}

extension YBTextButton.Appearance {
    
    var textColor: YBColor {
        switch self {
        case .default, .select: return .white
        case .defaultDisable: return .gray5
        case .selectDisable: return .gray4
        }
    }
    
    var backgroundColor: YBColor {
        switch self {
        case .default: return .black
        case .defaultDisable, .selectDisable: return .gray2
        case .select: return .gray6
        }
    }
}

extension YBTextButton.Size {
    
    var font: YBFont {
        switch self {
        case .large: return .title1
        case .medium: return .title1
        case .small: return .body1
        }
    }
    
    var height: CGFloat {
        switch self {
        case .large, .medium: return 54
        case .small: return 44
        }
    }
    
    var cornerRadius: CGFloat {
        return 10
    }
}
