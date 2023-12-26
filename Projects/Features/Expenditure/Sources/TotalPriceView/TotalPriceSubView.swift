//
//  TotalPriceSubView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

import DesignSystem
import RxGesture

final class TotalPriceSubView: UIView {

    var disposeBag: DisposeBag = DisposeBag()

    // MARK: label

    let titleLabel = YBLabel(font: .body3, textColor: .gray4)
    let priceLabel = YBLabel(font: .body3, textColor: .gray6)
    let verticalDivider = YBDivider(.verticalLine, height: 1, color: .gray3)

    init(isDivider: Bool = false) {
        
        super.init(frame: .zero)
        
        verticalDivider.isHidden = isDivider == false

        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(verticalDivider)

        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6).priority(.high)
            make.verticalEdges.equalToSuperview().priority(.low)
        }
        
        verticalDivider.snp.makeConstraints { make in
            make.leading.equalTo(priceLabel.snp.trailing).offset(6).priority(.low)
            make.verticalEdges.trailing.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(text: String, price: Int) {
        titleLabel.text = text
        priceLabel.text = "\(price)원"
    }
}
