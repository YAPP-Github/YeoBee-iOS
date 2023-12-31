//
//  HomeSectionHeaderView.swift
//  Home
//
//  Created by 박현준 on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

class HomeSectionHeaderView: UICollectionReusableView {
    static let identifier = "HomeSectionHeaderView"
    // MARK: - Properties
    let sectionTitleLabel: UILabel = {
        $0.font = YBFont.body1.font
        $0.textColor = YBColor.black.color
        return $0
    }(UILabel())
    
    // MARK: -  Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    private func addView() {
        addSubview(sectionTitleLabel)
    }
    
    private func setLayout() {
        sectionTitleLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(26)
        }
    }
}
