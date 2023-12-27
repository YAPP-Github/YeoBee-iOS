//
//  HomeAddTripView.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

class HomeAddTripView: UIView {

    private let greenCircleView: UIView = {
        $0.backgroundColor = YBColor.mainGreen.color
        $0.layer.cornerRadius = 22
        return $0
    }(UIView())
    
    private let tripTitleLabel: UILabel = {
        $0.text = "여행 등록하기"
        $0.font = YBFont.header2.font
        $0.textColor = YBColor.black.color
        return $0
    }(UILabel())
    
    private let tripSubTitleLabel: UILabel = {
        $0.text = "경비 관리를 위해 여행을 등록해보세요!"
        $0.font = YBFont.body3.font
        $0.textColor = YBColor.black.color
        return $0
    }(UILabel())
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addViews()
        setLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // MARK: - Set UI
    private func setView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    
    private func addViews() {
        [
            greenCircleView,
            tripTitleLabel,
            tripSubTitleLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        greenCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
            make.leading.equalToSuperview().inset(22)
        }
        tripTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(greenCircleView.snp.top)
            make.leading.equalTo(greenCircleView.snp.trailing).inset(-25)
        }
        tripSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tripTitleLabel.snp.bottom).inset(-5)
            make.leading.equalTo(tripTitleLabel.snp.leading)
        }
    }
}
