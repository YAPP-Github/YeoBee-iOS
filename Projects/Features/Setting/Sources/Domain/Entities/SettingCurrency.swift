//
//  SettingCurrency.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation

public struct SettingCurrency: Hashable {
    var code: String
    var value: Float
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(code)
    }
}
