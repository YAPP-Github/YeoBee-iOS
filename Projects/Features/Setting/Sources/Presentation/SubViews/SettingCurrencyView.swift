//
//  SettingCurrencyView.swift
//  Setting
//
//  Created by 박현준 on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

final class SettingCurrencyView: UIView {
    
    // MARK: - Properties
    private let defaultCurrencyBackgroundView: UIView = {
        $0.backgroundColor = YBColor.gray1.color
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    private let defaultNumberCurrencyLabel = YBLabel(text: "1", font: .body1, textColor: .gray4, textAlignment: .left)
    let defaultCurrencyLabel = YBLabel(font: .body1, textColor: .gray4)
    private let comparisonView = ComparisonView()
    
    private let wonCurrencyBackgroundView: UIView = {
        $0.backgroundColor = YBColor.gray1.color
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    let wonCurrencyTextField: UITextField = {
        $0.backgroundColor = .clear
        $0.keyboardType = .decimalPad
        $0.textAlignment = .left
        $0.font = YBFont.body1.font
        $0.textColor = YBColor.gray6.color
        return $0
    }(UITextField())
    
    private let wonCurrencyLabel = YBLabel(text: "원", font: .body1, textColor: .black)
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setLayouts()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            defaultCurrencyBackgroundView,
            comparisonView,
            wonCurrencyBackgroundView
        ].forEach {
            addSubview($0)
        }
        
        defaultCurrencyBackgroundView.addSubview(defaultNumberCurrencyLabel)
        defaultCurrencyBackgroundView.addSubview(defaultCurrencyLabel)
        
        wonCurrencyBackgroundView.addSubview(wonCurrencyTextField)
        wonCurrencyBackgroundView.addSubview(wonCurrencyLabel)
    }
    
    private func setLayouts() {
        defaultCurrencyBackgroundView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        comparisonView.snp.makeConstraints { make in
            make.leading.equalTo(defaultCurrencyBackgroundView.snp.trailing).inset(-16)
            make.centerY.equalTo(defaultCurrencyBackgroundView.snp.centerY)
            make.size.equalTo(25)
        }
        wonCurrencyBackgroundView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(comparisonView.snp.trailing).inset(-16)
        }
        defaultNumberCurrencyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
        }
        defaultCurrencyLabel.snp.makeConstraints { make in
            make.centerY.equalTo(defaultNumberCurrencyLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(15)
        }
        wonCurrencyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
        }
        wonCurrencyTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.centerY.equalTo(wonCurrencyLabel.snp.centerY)
            make.width.equalToSuperview().multipliedBy(0.72)
            make.height.equalToSuperview()
        }
    }
}
