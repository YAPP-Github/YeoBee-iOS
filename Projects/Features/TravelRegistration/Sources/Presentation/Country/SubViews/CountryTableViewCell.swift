//
//  CountryTableViewCell.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift
import RxCocoa
import SnapKit

protocol CountryTableViewCellDelegate: AnyObject {
    func checkedButtonTapped(country: Country)
}

class CountryTableViewCell: UITableViewCell {
    static let identifier = "CountryTableViewCell"
    
    var checkedButtonSelected: Bool = false {
        didSet {
            checkedButton.isSelected = checkedButtonSelected
        }
    }
    
    var country: Country? {
        didSet {
            configure()
        }
    }
    
    private let countryImageView: UIImageView = {
        $0.image = UIImage(systemName: "xmark")
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let countryNameLabel: UILabel = {
        $0.font = YBFont.body1.font
        $0.textColor = YBColor.black.color
        return $0
    }(UILabel())
    
    private let checkedButton: UIButton = {
        $0.setImage(DesignSystemAsset.Icons.disableCheck.image, for: .normal)
        $0.setImage(DesignSystemAsset.Icons.check.image, for: .selected)
        return $0
    }(UIButton())
    
    weak var delegate: CountryTableViewCellDelegate?
    var disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        addViews()
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        countryImageView.image = nil
        countryNameLabel.text = ""
        checkedButtonSelected = false
    }
    
    // MARK: - Set UI
    private func setView() {
        backgroundColor = YBColor.gray1.color
    }
    
    private func addViews() {
        [
            countryImageView,
            countryNameLabel,
            checkedButton,
        ].forEach {
            contentView.addSubview($0)
        }
    }
    private func setLayout() {
        countryImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.width.equalTo(42)
            make.height.equalTo(30)
        }
        countryNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(countryImageView.snp.trailing).offset(16)
            make.centerY.equalTo(countryImageView.snp.centerY)
        }
        checkedButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(countryImageView.snp.centerY)
            make.size.equalTo(30)
        }
    }
    
    func configure() {
        guard let country = country else { return }
        countryImageView.image = UIImage(systemName: "xmark")
        countryNameLabel.text = country.name
    }
    
    // MARK: - Action
    private func bind() {
        checkedButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self,
                      let country = country else { return }
                self.delegate?.checkedButtonTapped(country: country)
                self.checkedButtonSelected.toggle()
            }.disposed(by: disposeBag)
    }
}
