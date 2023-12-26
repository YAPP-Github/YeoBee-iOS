//
//  TotalPriceViewViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift

import DesignSystem

final class TotalPriceView: UIView {

    var disposeBag: DisposeBag = DisposeBag()

    // MARK: label

    let titleLabel = YBLabel(text: "총 쓴돈", font: .body3, textColor: .gray6)
    let priceLabel = YBLabel(text: "500,000원", font: .body3, textColor: .gray6)

    init() {
        super.init(frame: .zero)

        addSubview(titleLabel)
        addSubview(priceLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: TotalPriceReactor) {
        //binding here
    }
}
