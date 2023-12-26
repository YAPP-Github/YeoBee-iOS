//
//  YBRoundSegmentControl.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

public class YBSegmentControl: UISegmentedControl {
    
    public enum SegmentControlType {
        case round
        case rectangle
    }
    
    let type: SegmentControlType
    
    public init(_ type: SegmentControlType, items: [String]) {
        self.type = type
        super.init(items: items)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = type == .round ? 20 : 10
        layer.masksToBounds = true
        backgroundColor = YBColor.gray2.color
        
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex),
           let foregroundImageView = subviews[foregroundIndex] as? UIImageView {

            foregroundImageView.image = UIImage()
            foregroundImageView.backgroundColor = YBColor.white.color
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: 6.0,
                                                                            dy: 6.0)
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.cornerRadius = type == .round ? 20 : 10
        }
        
        let imageViews = self.subviews.filter({ $0 is UIImageView }).compactMap({ $0 as? UIImageView })
        for imageView in Array(imageViews[..<self.numberOfSegments]) {
            imageView.isHidden = true
        }
    }
}

private extension YBSegmentControl {
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: YBColor.black.color,
                                     NSAttributedString.Key.font: YBFont.body3.font],
                                    for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: YBColor.gray5.color,
                                     NSAttributedString.Key.font: YBFont.body3.font],
                                    for: .normal)
        
        self.selectedSegmentIndex = 0
        self.backgroundColor = .clear
    }
}

