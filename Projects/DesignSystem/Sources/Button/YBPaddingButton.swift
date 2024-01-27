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
                borderColor: YBColor? = nil,
                isGradient: Bool,
                padding: Padding = .medium) {
        self.padding = padding.insets
        super.init(frame: .zero)
        setTitle(text, for: .normal)
        if isGradient {
            configureGradient(font: font)
        } else {
            configure(font: font,
                      titleColor: titleColor,
                      selectedTitleColor: selectedTitleColor,
                      bgColor: backgroundColor,
                      selectedBgColor: selectedBgColor,
                      borderColor: borderColor)
        }
        clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect.inset(by: padding))
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    public override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        if contentSize == .zero { return contentSize }
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }
    
    func configureGradient(font: YBFont) {
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
        if let gradientLayer = gradientLayer {
            layer.cornerRadius = 18
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func configure(font: YBFont,
                   titleColor: YBColor,
                   selectedTitleColor: YBColor,
                   bgColor: YBColor,
                   selectedBgColor: YBColor,
                   borderColor: YBColor?) {
        titleLabel?.font = font.font
        setTitleColor(titleColor.color, for: .normal)
        setBackgroundColor(bgColor.color, for: .normal)
        setTitleColor(selectedTitleColor.color, for: .highlighted)
        setBackgroundColor(selectedBgColor.color, for: .highlighted)
        setTitleColor(selectedTitleColor.color, for: .selected)
        setBackgroundColor(selectedBgColor.color, for: .selected)
        layer.cornerRadius = 20
        
        if let borderColor = borderColor, state != .selected {
            self.layer.borderColor = borderColor.color.cgColor
            self.layer.borderWidth = 0.4
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
    case custom(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)
    
    var insets: UIEdgeInsets {
        switch self {
        case .small:
            return UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        case .medium:
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        case .large:
            return UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        case .custom(let top, let left, let bottom, let right):
            return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        }
    }
}
