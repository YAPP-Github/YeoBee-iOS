//
//  YBDividerView+SwiftUI.swift
//  DesignSystem
//
//  Created by Hoyoung Lee on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import SwiftUI

public struct YBDividerView: View {
    let color: YBColor
    let height: CGFloat

    public init(color: YBColor = .gray3, height: CGFloat = 1) {
        self.color = color
        self.height = height
    }

    public var body: some View {
        Rectangle()
            .frame(height: height)
            .foregroundColor(color.swiftUIColor)
    }
}
