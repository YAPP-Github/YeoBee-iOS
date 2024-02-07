//
//  SettingTableHeaderView.swift
//  Setting
//
//  Created by 박현준 on 2/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

protocol SettingTableHeaderViewDelegate: AnyObject {
    func modifyButtonTapped()
}

final class SettingTableHeaderView: UIView {
    
    weak var delegate: SettingTableHeaderViewDelegate?
    
    //MARK: - Properties
    private let backgroundImageView: UIImageView = {
        $0.backgroundColor = .systemMint
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFit
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
    
    private let titleLabel = YBLabel(font: .header2, textColor: .black)
    private let dateLabel = YBLabel(font: .body3, textColor: .gray5)
    
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
    func setUI() {
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
    
    func setConstraints() {
        countryImageView.snp.makeConstraints { make in
            make.height.equalTo(18)
            make.width.equalTo(25)
        }
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
        backgroundImageView.snp.makeConstraints { make in
            make.bottom.equalTo(titleLabel.snp.top).inset(-22)
            make.leading.trailing.equalToSuperview().inset(24).priority(.low)
            make.top.equalToSuperview().inset(22)
        }
        stackView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure() {
        countryImageView.image = UIImage(systemName: "xmark")
        countryLabel.text = "프랑스"
        titleLabel.text = "여행 어쩌구"
        dateLabel.text = "2024년 02월 06일 ~ 2024년 02월 30일"
    }
    
    // MARK: - Handler
    @objc func modifyButtonTapped() {
        delegate?.modifyButtonTapped()
    }
}
