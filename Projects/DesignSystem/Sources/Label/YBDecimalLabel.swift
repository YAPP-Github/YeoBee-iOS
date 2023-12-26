//
//  YBDecimalLabel.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/26.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import SnapKit

public final class YBDecimalLabel: UILabel {
    
    public enum Unit: Equatable {
        case krw
        case etc(String)
    }
    let unit: Unit
    let unitString: String
    
    public init(price: Int = 0,
                unit: Unit = .krw,
                font: YBFont,
                textColor: YBColor,
                textAlignment: NSTextAlignment = .left
    ) {
        self.unit = unit
        if case let .etc(string) = unit {
            unitString = string
        } else {
            unitString = "원"
        }
        super.init(frame: .zero)
        
        self.lineBreakMode = .byTruncatingTail
        self.font = font.font
        self.textColor = textColor.color
        self.text = unit == .krw ? price.formattedWithSeparator + "원" : String(price) + unitString
        self.textAlignment = textAlignment
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension YBDecimalLabel {
    func setPrice(_ price: Int) {
        self.text = unit == .krw ? price.formattedWithSeparator + "원" : String(price) + unitString
    }
}

private extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
