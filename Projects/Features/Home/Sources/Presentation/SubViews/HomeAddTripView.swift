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

    private let plusCircleView : UIImageView = {
        $0.image = DesignSystemAsset.Icons.plusButton.image
        $0.layer.cornerRadius = 22
        return $0
    }(UIImageView())
    
    private let tripTitleLabel = YBLabel(text: "여행 등록하기", font: .header2, textColor: .black)
    private let tripSubTitleLabel = YBLabel(text: "경비 관리를 위해 여행을 등록해보세요!", font: .body3, textColor: .black)
    
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
        layer.cornerRadius = 12
        clipsToBounds = true
    }
    
    private func addViews() {
        [
            plusCircleView,
            tripTitleLabel,
            tripSubTitleLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func setLayouts() {
        plusCircleView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(44)
            make.leading.equalToSuperview().inset(22)
        }
        tripTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(plusCircleView.snp.top)
            make.leading.equalTo(plusCircleView.snp.trailing).inset(-25)
        }
        tripSubTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tripTitleLabel.snp.bottom).inset(-5)
            make.leading.equalTo(tripTitleLabel.snp.leading)
        }
    }
}
