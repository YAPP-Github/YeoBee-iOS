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

    let titleLabel = YBLabel(text: "", font: .body3, textColor: .gray6)
    let priceLabel = YBLabel(text: "", font: .header1, textColor: .gray6)

    init(text: String, price: Int) {
        titleLabel.text = text
        priceLabel.text = "\(price)원"
        
        super.init(frame: .zero)

        addSubview(titleLabel)
        addSubview(priceLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.verticalEdges.trailing.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
