//
//  YBIconWithTextButton.swift
//  DesignSystem
//
//  Created by 김태형 on 2/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBIconWithTextButton: UIButton {
    
    let size: Size
    var appearance: Appearance
    
    public init(text: String, appearance: Appearance? = .apple, size: Size? = .default) {
        self.size = size ?? .default
        self.appearance = appearance ?? .apple
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: size?.height ?? 54).isActive = true
        
        setTitle(text, for: .normal)
        self.setImage(appearance?.icon, for: .normal)
        
        configureConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension YBIconWithTextButton {
    
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
        ybConfiguration.imagePadding = 10
        configuration = ybConfiguration
    }
}

public extension YBIconWithTextButton {
    
    func setAppearance(appearance: Appearance) {
        self.appearance = appearance
        configureConfiguration()
    }
}

public extension YBIconWithTextButton {
    enum Appearance {
        case apple
        case kakao
        case `default`
    }
    
    enum Size {
        case `default`
    }
}

extension YBIconWithTextButton.Appearance {
    
    var textColor: YBColor {
        switch self {
        case .apple, .default: return .white
        case .kakao: return .black
        }
    }
    
    var backgroundColor: YBColor {
        switch self {
        case .apple, .default: return .black
        case .kakao: return .kakaoYellow
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .apple: return DesignSystemImages(name: "apple").image
        case .kakao: return DesignSystemImages(name: "kakao").image
        case .default: return nil
        }
    }
}

extension YBIconWithTextButton.Size {
    
    var font: YBFont {
        switch self {
        case .default: .title1
        }
    }
    
    var height: CGFloat {
        switch self {
        case .default: 54
        }
    }
    
    var cornerRadius: CGFloat {
        return 10
    }
}
