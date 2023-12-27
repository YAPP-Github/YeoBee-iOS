//
//  HomeCollectionViewCell.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionViewCell"
    // MARK: - Properties
    
    private let backgroundImageView: UIImageView = {
        $0.backgroundColor = .systemPink
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.font = YBFont.body1.font
        $0.textColor = YBColor.black.color
        return $0
    }(UILabel())
    
    private let dateLabel: UILabel = {
        $0.font = YBFont.body3.font
        $0.textColor = YBColor.gray6.color
        return $0
    }(UILabel())
    
    private let countryImageView: UIImageView = {
        $0.layer.cornerRadius = 4
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let countryLabel: UILabel = {
        $0.font = YBFont.header2.font
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let otherCountryLabel: UILabel = {
        $0.font = YBFont.body1.font
        $0.textColor = .white
        return $0
    }(UILabel())
    
    private let stackView: UIStackView = {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fill
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
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    func configure() {
        titleLabel.text = "유럽 여행 고고링"
        dateLabel.text = "2023년 12월 18일 - 2023년 12월 31일"
        countryLabel.text = "프랑스"
        countryImageView.image = UIImage(systemName: "xmark")
        otherCountryLabel.text = "외 2개국"
    }
}
