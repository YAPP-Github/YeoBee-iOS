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
    private var gradientLayer: CAGradientLayer?
    
    public init(text: String,
                font: YBFont = .body2,
                titleColor: YBColor = .gray4,
                selectedTitleColor: YBColor = .white,
                backgroundColor: YBColor = .gray2,
                selectedBgColor: YBColor = .black,
                isGradient: Bool,
                padding: Padding = .medium) {
        self.padding = padding.insets
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        if isGradient {
            configureGradient(font: font, padding: padding)
        } else {
            configure(font: font,
                      titleColor: titleColor,
                      selectedTitleColor: selectedTitleColor,
                      bgColor: backgroundColor,
                      selectedBgColor: selectedBgColor,
                      padding: padding)
        }
        clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: padding))
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = bounds
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    
    
    func configureGradient(font: YBFont, padding: Padding) {
        setTitleColor(YBColor.white.color, for: .normal)
        titleLabel?.font = font.font
        let gradientColors = [YBColor.mediumGreen.color, YBColor.mainGreen.color]
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 1, y: 1)
        
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = bounds
        gradientLayer?.colors = gradientColors.map { $0.cgColor }
        gradientLayer?.startPoint = startPoint
        gradientLayer?.endPoint = endPoint
        paddingForRadius(padding: padding)
        if let gradientLayer = gradientLayer {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func configure(font: YBFont,
                   titleColor: YBColor,
                   selectedTitleColor: YBColor,
                   bgColor: YBColor,
                   selectedBgColor: YBColor,
                   padding: Padding) {
        titleLabel?.font = font.font
        setTitleColor(titleColor.color, for: .normal)
        setBackgroundColor(bgColor.color, for: .normal)
        setTitleColor(selectedTitleColor.color, for: .highlighted)
        setBackgroundColor(selectedBgColor.color, for: .highlighted)
        setTitleColor(selectedTitleColor.color, for: .selected)
        setBackgroundColor(selectedBgColor.color, for: .selected)
        paddingForRadius(padding: padding)
        
    }
    
    private func paddingForRadius(padding: Padding) {
        switch padding {
        case .small:
            return layer.cornerRadius = 14
        case .medium:
            return layer.cornerRadius = 16
        case .large:
            return layer.cornerRadius = 18
        case .calendarDate:
            return layer.cornerRadius = 20
        case .gradient:
            return layer.cornerRadius = 20
        case .custom:
            return layer.cornerRadius = 15
        }
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
    case gradient
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
        case .gradient:
            return UIEdgeInsets(top: 6.5, left: 14, bottom: 6.5, right: 14)
        case .custom(let top, let left, let bottom, let right):
            return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
}
