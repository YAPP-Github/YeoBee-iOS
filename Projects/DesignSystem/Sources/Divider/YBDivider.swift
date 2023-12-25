//
//  YBDivider.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBDivider: UIView {
    
    private let borderLayer = CAShapeLayer()
    
    public enum DividerType {
        case line
        case dotLine
    }
    
    public init(_ type: DividerType = .line, height: CGFloat, color: YBColor) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        if case type = .dotLine {
            borderLayer.strokeColor = color.color.cgColor
            borderLayer.lineDashPattern = [4, 4]
            borderLayer.backgroundColor = UIColor.clear.cgColor
            borderLayer.fillColor = UIColor.clear.cgColor
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: 300, y: 0)])
            
            borderLayer.path = path
            layer.addSublayer(borderLayer)
        } else {
            self.backgroundColor = color.color
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
