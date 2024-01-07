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
                borderColor: YBColor? = nil, font: YBFont, textAlignment: NSTextAlignment = .center, padding: Padding = .calendarDate) {
        self.padding = padding.insets
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        configure(bgColor: backgroundColor,
                  txtColor: textColor,
                  brdColor: borderColor,
                  ft: font,
                  padding: padding)
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
    
    func configure(bgColor: YBColor, txtColor: YBColor, brdColor: YBColor? = nil, ft: YBFont, padding: Padding) {
        self.backgroundColor = bgColor.color
        self.textColor = txtColor.color
        self.font = ft.font
        
        if brdColor != nil {
            self.layer.borderColor = brdColor?.color.cgColor
            self.layer.borderWidth = 0.6
        }
        
        switch padding {
        case .small:
            layer.cornerRadius = 14
        case .medium:
            layer.cornerRadius = 16
        case .large:
            layer.cornerRadius = 18
        case .calendarDate:
            layer.cornerRadius = 16
        case .custom:
            layer.cornerRadius = 15
        }
        clipsToBounds = true
    }
}
