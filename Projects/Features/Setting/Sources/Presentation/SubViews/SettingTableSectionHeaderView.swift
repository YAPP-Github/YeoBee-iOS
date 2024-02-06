//
//  SettingTableSectionHeaderView.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem

final class SettingTableSectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "SettingTableSectionHeaderView"
    
    // MARK: - Properties
    let sectionTitleLabel = YBLabel(font: .title1, textColor: .black)
    
    // MARK: -  Life Cycles
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
