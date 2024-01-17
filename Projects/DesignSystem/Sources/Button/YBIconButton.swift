//
//  YBIconButton.swift
//  DesignSystem
//
//  Created by 박현준 on 1/7/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

public final class YBIconButton: UIButton {
    
    public init(image: UIImage?, selectedImage: UIImage? = nil, tintColor: YBColor? = nil) {
        super.init(frame: .zero)
        configure(image: image, selectedImage: selectedImage, tintColor: tintColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(image: UIImage?, selectedImage: UIImage?, tintColor: YBColor? = nil) {
        if let color = tintColor {
            let img = image?.withTintColor(color.color, renderingMode: .alwaysOriginal)
            self.setImage(img, for: .normal)
        } else {
            self.setImage(image, for: .normal)
        }
        
        if let selectedImage = selectedImage {
            self.setImage(selectedImage, for: .selected)
        }
    }
}
