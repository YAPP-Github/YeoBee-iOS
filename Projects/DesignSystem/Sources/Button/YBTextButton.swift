//
//  YBTextButton.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBTextButton: UIButton {
    
    let size: Size
    var appearance: Appearance
    
    public init(text: String, appearance: Appearance, size: Size) {
        self.size = size
        self.appearance = appearance
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        
        setTitle(text, for: .normal)
        configureConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension YBTextButton {
    
    func configureConfiguration() {
        var ybConfiguration: UIButton.Configuration = .filled()
        ybConfiguration.baseBackgroundColor = appearance.backgroundColor.color
        ybConfiguration.baseForegroundColor = appearance.textColor.color
        ybConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer (
            { [weak self] incoming in
                var outgoing = incoming
                outgoing.font = self?.size.font.font
                return outgoing
            }
        )
        ybConfiguration.background.cornerRadius = size.cornerRadius
        ybConfiguration.background.strokeWidth = 1.0
        configuration = ybConfiguration
    }
}

public extension YBTextButton {
    
    func setAppearance(appearance: Appearance) {
        self.appearance = appearance
        configureConfiguration()
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
        case .defaultDisable: return .gray3
        case .selectDisable: return .gray2
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
