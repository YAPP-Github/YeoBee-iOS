//
//  SettingCurrencyCell.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Entity
import DesignSystem

class SettingCurrencyCell: UITableViewCell {
    static let identifier = "SettingCurrencyCell"
    
    var currency: Currency? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Properties
    private let backgroundCurrencyView: UIView = {
        $0.backgroundColor = YBColor.gray1.color
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        return $0
    }(UIView())
    
    private let currencyLabel = YBLabel(font: .title1, textColor: .gray6)
    private let nextButton = YBIconButton(image: DesignSystemAsset.Icons.next.image)
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        addViews()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        currencyLabel.text = ""
    }
    
    // MARK: - Set UI
    private func setView() {
        selectionStyle = .none
    }
    
    private func addViews() {
        addSubview(backgroundCurrencyView)
        
        [
            currencyLabel,
            nextButton
        ].forEach {
            backgroundCurrencyView.addSubview($0)
        }
    }
    private func setLayout() {
        backgroundCurrencyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.bottom.equalToSuperview().inset(8)
        }
        currencyLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(24)
        }
    }
    
    func configure() {
        guard let currency else { return }
        currencyLabel.text = "\(currency.exchangeRate.standard) \(currency.code) = \(currency.exchangeRate.value)원"
        nextButton.isHidden = true
    }
}
