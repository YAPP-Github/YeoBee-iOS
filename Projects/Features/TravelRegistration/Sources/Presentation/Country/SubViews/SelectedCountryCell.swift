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
    
    private let countryNameLabel = YBLabel(font: .body3, textColor: .black, textAlignment: .center)
    
    private let countryImageView: UIImageView = {
        $0.image = UIImage(systemName: "xmark")
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let deleteButton = YBIconButton(image: DesignSystemAsset.Icons.circleDeleteButton.image)
    
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
            make.top.equalToSuperview().inset(9)
            make.leading.equalToSuperview().inset(3)
            make.width.equalTo(42)
            make.height.equalTo(30)
        }
        countryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(countryImageView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
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
                self.delegate?.deleteButtonTapped(country: country)
            }.disposed(by: disposeBag)
    }
}
