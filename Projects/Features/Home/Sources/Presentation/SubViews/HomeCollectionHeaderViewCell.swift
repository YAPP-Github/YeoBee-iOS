//
//  HomeCollectionHeaderViewCell.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

protocol HomeCollectionHeaderViewCellDelegate: AnyObject {
    func chevronButtonTapped()
    func addTripViewTapped()
}

class HomeCollectionHeaderViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionHeaderViewCell"
    var disposeBag = DisposeBag()
    weak var delegate: HomeCollectionHeaderViewCellDelegate?
    // MARK: - Properties
    private let profileImageView: UIImageView = {
        $0.image = UIImage(systemName: "circle")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 30 / 2
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private let profileNameLabel: UILabel = {
        $0.text = "양송이"
        $0.font = YBFont.body2.font
        $0.textColor = .black
        return $0
    }(UILabel())
    
    let chevronButton: UIButton = {
        $0.setImage(DesignSystemAsset.Icons.rightChevron.image , for: .normal)
        return $0
    }(UIButton())
    
    let addTripView = HomeAddTripView()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addViews()
        setLayouts()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // MARK: - Set UI
    private func setView() {
        backgroundColor = .clear
    }
    
    private func addViews() {
        [
            profileImageView,
            profileNameLabel,
            chevronButton,
            addTripView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        chevronButton.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(6)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        addTripView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(95).priority(.low)
        }
    }
    
    private func bind() {
        chevronButton.rx.tap
            .bind { [weak self] _ in
                self?.delegate?.chevronButtonTapped()
            }.disposed(by: disposeBag)
        
        addTripView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.delegate?.addTripViewTapped()
            }.disposed(by: disposeBag)
    }
}
