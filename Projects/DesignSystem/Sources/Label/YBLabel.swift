//
//  YBLabel.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBLabel: UILabel {
    
    public init(text: String,
                font: YBFont,
                textColor: YBColor = .black,
                textAlignment: NSTextAlignment = .left
    ) {
        super.init(frame: .zero)
        
        self.font = font.font
        self.textColor = textColor.color
        self.text = text
        self.textAlignment = textAlignment
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension YBLabel {
     
    /// 행간이 추가되어야하는 경우 사용
    func setLineHeight(lineHeight: CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            style.alignment = self.textAlignment
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4,
            ]
                
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
