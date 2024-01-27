//
//  CountrySectionHeaderView.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/2/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

class CountrySectionHeaderView: UITableViewHeaderFooterView {
    static let identifier = "CountrySectionHeaderView"
    // MARK: - Properties
    let sectionTitleLabel = YBLabel(font: .body1, textColor: .black)
    
    // MARK: -  Life Cycles
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }
    }
}
