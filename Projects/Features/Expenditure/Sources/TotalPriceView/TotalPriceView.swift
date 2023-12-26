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
import RxGesture

final class TotalPriceView: UIView, View {

    var disposeBag: DisposeBag = DisposeBag()

    // MARK: label

    let titleLabel = YBLabel(text: "", font: .body3, textColor: .gray6)
    let priceLabel = YBLabel(text: "", font: .header1, textColor: .gray6)
    let divider = YBDivider(height: 1, color: .gray3)
    let stackView = UIStackView()
    let secondDivider = YBDivider(height: 1, color: .gray3)
    let totalPriceSubView = TotalPriceSubView(text: "", price: 0)

    init() {
        super.init(frame: .zero)

        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(divider)
        addSubview(stackView)

        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
        }

        divider.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview()
        }

        stackView.axis = .horizontal
        stackView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(8)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(reactor: TotalPriceReactor) {
        let hasBudget: Bool = reactor.currentState.budget > 0

        if hasBudget {
            setTitleLabel(text: "예산 잔액", price: 1000)
        } else {
            setTitleLabel(text: "총 쓴돈", price: 50000)
        }

        self.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { gesture in
                if hasBudget {
                    print("모인 돈 내역")
                } else {
                    print("총 쓴돈 내역")
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: titleLabel

extension TotalPriceView {
    func setTitleLabel(text: String, price: Int) {
        titleLabel.text = text
        priceLabel.text = "\(price)원"
    }
}
