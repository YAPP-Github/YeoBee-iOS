//
//  YBPaddingButton.swift
//  DesignSystem
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBPaddingButton: UIButton {
    
    private let padding: UIEdgeInsets
    
    public init(text: String, padding: Padding = .medium) {
        self.padding = padding.insets
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        configure(padding: padding)
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
    
    func configure(padding: Padding) {
        titleLabel?.font = YBFont.body2.font
        setTitleColor(YBColor.gray4.color, for: .normal)
        setBackgroundColor(YBColor.gray2.color, for: .normal)
        setTitleColor(YBColor.white.color, for: .highlighted)
        setBackgroundColor(YBColor.black.color, for: .highlighted)
        setTitleColor(YBColor.white.color, for: .selected)
        setBackgroundColor(YBColor.black.color, for: .selected)
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
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(backgroundImage, for: state)
    }
}

public enum Padding {
    case small
    case medium
    case large
    case calendarDate
    case custom(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
    
    var insets: UIEdgeInsets {
        switch self {
        case .small:
            return UIEdgeInsets(top: 4.5, left: 16, bottom: 4.5, right: 16)
        case .medium:
            return UIEdgeInsets(top: 7, left: 20, bottom: 7, right: 20)
        case .large:
            return UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        case .calendarDate:
            return UIEdgeInsets(top: 7.5, left: 14, bottom: 7.5, right: 14)
        case .custom(let top, let left, let bottom, let right):
            return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
}
