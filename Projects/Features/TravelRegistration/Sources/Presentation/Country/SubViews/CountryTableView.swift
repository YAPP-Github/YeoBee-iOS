//
//  CountryTableView.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/31/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem

final class CountryTableView: UITableView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setView()
    }
    
    private func setView() {
        register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.identifier)
        backgroundColor = YBColor.gray1.color
        separatorInset.left = 0
        rowHeight = 50
        separatorStyle = .none
    }
}
