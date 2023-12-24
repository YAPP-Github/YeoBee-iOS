//
//  YBTextField.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/24.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

public class YBTextField: UITextField {
    let insetX: CGFloat = 20
    
    public init(
        backgroundColor: YBColor = .gray1
    ) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = backgroundColor.color
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension YBTextField {
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: 0.0)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: insetX, y: 0, width: bounds.size.width - (insetX * 2), height: bounds.size.height)
    }
    
    public override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: insetX, y: 0, width: bounds.size.width - (insetX * 2), height: bounds.size.height)
    }
}

private extension YBTextField {
    
    func configureUI() {
        self.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        self.font = .ybfont(.body1)
        self.tintColor = .ybColor(.black)
        self.textColor = .ybColor(.black)
        self.layer.cornerRadius = 10
    }
}

public extension YBTextField {
    func setPlaceholder(_ string: String) {
        attributedPlaceholder = NSAttributedString(string: string, attributes: [
            .foregroundColor: YBColor.gray5.color,
            .font: YBFont.body1.font
        ])
    }
}

