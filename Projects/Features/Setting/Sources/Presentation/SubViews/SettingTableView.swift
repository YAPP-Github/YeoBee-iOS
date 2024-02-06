//
//  SettingTableView.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

final class SettingTableView: UITableView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setView()
    }
    
    private func setView() {
        register(SettingCurrencyCell.self, forCellReuseIdentifier: SettingCurrencyCell.identifier)
        register(SettingCompanionCell.self, forCellReuseIdentifier: SettingCompanionCell.identifier)
        register(SettingTableSectionHeaderView.self,
                 forHeaderFooterViewReuseIdentifier: SettingTableSectionHeaderView.identifier)
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        separatorInset.left = 0
        separatorStyle = .none
    }
}
