//
//  CompanionTableView.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/9/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit

final class CompanionTableView: UITableView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setView()
    }
    
    private func setView() {
        register(CompanionTableViewCell.self, forCellReuseIdentifier: CompanionTableViewCell.identifier)
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        separatorInset.left = 0
        rowHeight = 60
        separatorStyle = .none
    }
}
