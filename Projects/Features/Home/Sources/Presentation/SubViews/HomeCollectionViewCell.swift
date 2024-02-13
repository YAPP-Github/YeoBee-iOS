//
//  HomeCollectionViewCell.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import Kingfisher
import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"
    // MARK: - Properties
    private let backgroundImageView: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    private let titleLabel = YBLabel(font: .body1, textColor: .black)
    private let dateLabel = YBLabel(font: .body3, textColor: .gray6)
    
    private let countryImageView: UIImageView = {
        $0.layer.cornerRadius = 4
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let countryLabel = YBLabel(font: .header2, textColor: .white)
    private let otherCountryLabel = YBLabel(font: .body1, textColor: .white)
    
    private let stackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
        $0.alignment = .center
        return $0
    }(UIStackView())
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        titleLabel.text = ""
        dateLabel.text = ""
        countryLabel.text = ""
        countryImageView.image = nil
        otherCountryLabel.text = ""
    }
    
    // MARK: - Set UI
    private func setView() {
        backgroundColor = .white
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    private func addView() {
        [
            backgroundImageView,
            titleLabel,
            dateLabel
        ].forEach {
            addSubview($0)
        }
        
        [
            countryImageView,
            countryLabel,
            otherCountryLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        
        backgroundImageView.addSubview(stackView)
    }
    
    private func setLayout() {
        countryImageView.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(25)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.61)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).inset(-20)
            make.leading.equalToSuperview().inset(20)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        stackView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().inset(22)
        }
    }
    
    func configure(tripItem: TripItem) {
        guard let firstCountry = tripItem.countryList.first,
              let coverImageUrl = URL(string: firstCountry.coverImageUrl),
              let flagImageUrl = URL(string: firstCountry.flagImageUrl) else { return }
              
        titleLabel.text = tripItem.title
        dateLabel.text = "\(tripItem.startDate) - \(tripItem.endDate)"
        countryLabel.text = firstCountry.name
        backgroundImageView.kf.indicatorType = .activity
        countryImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: coverImageUrl)
        countryImageView.kf.setImage(with: flagImageUrl)
        if tripItem.countryList.count-1 > 0 {
            otherCountryLabel.text = "외 \(tripItem.countryList.count-1)개국"
        } else {
            otherCountryLabel.text = ""
        }
    }
}
