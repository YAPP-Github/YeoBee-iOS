//
//  SettingTableHeaderView.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import SnapKit
import Kingfisher

protocol SettingTableHeaderViewDelegate: AnyObject {
    func modifyButtonTapped()
}

final class SettingTableHeaderView: UIView {
    
    weak var delegate: SettingTableHeaderViewDelegate?
    
    //MARK: - Properties
    private let backgroundImageView: UIImageView = {
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
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
    
    private var titleLabel = YBLabel(text: " ", font: .header2, textColor: .black)
    private var dateLabel = YBLabel(text: " ",font: .body3, textColor: .gray5)
    
    private let modifyButton: UIButton = {
        $0.setTitle("편집", for: .normal)
        $0.setTitleColor(YBColor.gray4.color, for: .normal)
        $0.titleLabel?.font = YBFont.body3.font
        $0.addTarget(self, action: #selector(modifyButtonTapped), for: .touchUpInside)
        return $0
    }(UIButton())
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Set UI
    private func setUI() {
        [
            backgroundImageView,
            titleLabel,
            dateLabel,
            modifyButton
        ].forEach {
            addSubview($0)
        }
        
        backgroundImageView.addSubview(stackView)
        
        [
            countryImageView,
            countryLabel,
            otherCountryLabel
        ].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(dateLabel.snp.top).inset(-15)
            make.leading.equalTo(dateLabel.snp.leading)
        }
        modifyButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        countryImageView.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(25)
        }
        backgroundImageView.snp.makeConstraints { make in
            make.bottom.equalTo(modifyButton.snp.top).inset(-22)
            make.width.equalTo(UIScreen.main.bounds.width-46)
            make.top.equalToSuperview().inset(22)
            make.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(28)
        }
    }
    
    func configure(tripItem: TripItem) {
        guard let firstCountry = tripItem.countryList.first,
              let flagImageUrl = URL(string: firstCountry.flagImageUrl) else { return }
        countryLabel.text = firstCountry.name
        titleLabel.text = tripItem.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let startDate = dateFormatter.date(from: tripItem.startDate),
           let endDate = dateFormatter.date(from: tripItem.endDate) {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let formattedStartDate = dateFormatter.string(from: startDate)
            let formattedEndDate = dateFormatter.string(from: endDate)
            dateLabel.text = "\(formattedStartDate) ~ \(formattedEndDate)"
        }
        
        // 선택한 나라 1개 이상
        if tripItem.countryList.count > 1 {
            otherCountryLabel.text = "외 \(tripItem.countryList.count-1)개국"
        }
        
        countryImageView.kf.indicatorType = .activity
        countryImageView.kf.setImage(with: flagImageUrl)
        guard let coverImageUrl = URL(string: firstCountry.coverImageUrl ?? "") else { return }
        backgroundImageView.kf.indicatorType = .activity
        backgroundImageView.kf.setImage(with: coverImageUrl)

    }
    
    // MARK: - Handler
    @objc func modifyButtonTapped() {
        delegate?.modifyButtonTapped()
    }
}
