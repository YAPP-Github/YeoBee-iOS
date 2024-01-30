//
//  HomeSectionHeaderView.swift
//  Home
//
//  Created by 박현준 on 12/29/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import RxSwift

class HomeSectionHeaderView: UICollectionReusableView {
    static let identifier = "HomeSectionHeaderView"
    var disposeBag = DisposeBag()
    
    // MARK: - Properties
    let sectionTitleLabel = YBLabel(font: .body1, textColor: .black)
    
    let moreButton: UIButton = {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = YBFont.body3.font
        $0.setTitleColor(YBColor.gray4.color, for: .normal)
        $0.isHidden = true
        return $0
    }(UIButton())
    
    // MARK: -  Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    private func addView() {
        addSubview(sectionTitleLabel)
        addSubview(moreButton)
    }
    
    private func setLayout() {
        sectionTitleLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(26)
        }
        moreButton.snp.makeConstraints {
            $0.centerY.equalTo(sectionTitleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(26)
        }
    }
}
