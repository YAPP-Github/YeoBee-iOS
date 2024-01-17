//
//  YBPaddingLabel.swift
//  DesignSystem
//
//  Created by 박현준 on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBPaddingLabel: UILabel {
    
    private let padding: UIEdgeInsets
    
    public init(text: String, backgroundColor: YBColor, textColor: YBColor, 
                borderColor: YBColor? = nil, font: YBFont, textAlignment: NSTextAlignment = .center, padding: Padding) {
        self.padding = padding.insets
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        configure(bgColor: backgroundColor,
                  textColor: textColor,
                  borderColor: borderColor,
                  font: font)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: padding))
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    func configure(bgColor: YBColor, textColor: YBColor, borderColor: YBColor? = nil, font: YBFont) {
        self.backgroundColor = bgColor.color
        self.textColor = textColor.color
        self.font = font.font
        
        if let borderColor = borderColor {
            self.layer.borderColor = borderColor.color.cgColor
            self.layer.borderWidth = 1
        }
        
        layer.cornerRadius = 20
        clipsToBounds = true
    }
}
