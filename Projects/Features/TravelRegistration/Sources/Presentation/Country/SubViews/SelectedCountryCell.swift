//
//  SelectedCountryCell.swift
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

protocol SelectedCountryCellDelegate: AnyObject {
    func deleteButtonTapped(country: Country)
}

class SelectedCountryCell: UICollectionViewCell {
    static let identifier = "SelectedCountryCell"
    
    // MARK: - Properties
    var country: Country? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: SelectedCountryCellDelegate?
    
    var disposeBag = DisposeBag()
    
    private let countryNameLabel: UILabel = {
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = YBFont.body3.font
        $0.textColor = YBColor.black.color
        return $0
    }(UILabel())
    
    private let countryImageView: UIImageView = {
        $0.image = UIImage(systemName: "xmark")
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let deleteButton: UIButton =  {
        $0.setImage(DesignSystemAsset.Icons.circleDeleteButton.image, for: .normal)
        return $0
    }(UIButton())
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            countryImageView,
            countryNameLabel,
            deleteButton
        ].forEach {
            addSubview($0)
        }
    }
    private func setLayout() {
        countryImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        countryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(countryImageView.snp.bottom).offset(6)
            make.leading.trailing.equalToSuperview().inset(5)
            make.centerX.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(5)
            make.size.equalTo(24)
        }
    }
    
    func configure() {
        guard let country = country else { return }
        // 이미지 변경
        countryImageView.image = UIImage(systemName: "xmark")
        countryNameLabel.text = country.name
    }
    
    // MARK: - Handler
    private func bind() {
        deleteButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self,
                      let country = country else { return }
                delegate?.deleteButtonTapped(country: country)
            }.disposed(by: disposeBag)
    }
}
