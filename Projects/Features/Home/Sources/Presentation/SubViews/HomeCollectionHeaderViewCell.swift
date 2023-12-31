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
    func profileButtonTapped()
    func addTripViewTapped()
}

class HomeCollectionHeaderViewCell: UICollectionViewCell {
    static let identifier = "HomeCollectionHeaderViewCell"
    var disposeBag = DisposeBag()
    weak var delegate: HomeCollectionHeaderViewCellDelegate?
    // MARK: - Properties
    
    let profileButton = HomeProfileButton()
    
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
            profileButton,
            addTripView
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        profileButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(32)
        }
        addTripView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(95).priority(.low)
        }
    }
    
    private func bind() {
        profileButton.profileStackView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.delegate?.profileButtonTapped()
            }.disposed(by: disposeBag)
        
        addTripView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                self?.delegate?.addTripViewTapped()
            }.disposed(by: disposeBag)
    }
}
