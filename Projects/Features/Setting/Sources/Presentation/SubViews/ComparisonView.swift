//
//  ComparisonView.swift
//  Setting
//
//  Created by 박현준 on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

public final class ComparisonView: UIView {
    
    // MARK: - Properties
    private let equalImageView: UIImageView = {
        $0.image = UIImage(systemName: "equal")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        return $0
    }(UIImageView())
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addViews()
        setLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // MARK: - Set UI
    private func setView() {
        backgroundColor = YBColor.gray3.color
        layer.cornerRadius = 12.5
        clipsToBounds = true
    }
    
    private func addViews() {
        addSubview(equalImageView)
    }
    
    private func setLayouts() {
        equalImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(16)
        }
    }
}
