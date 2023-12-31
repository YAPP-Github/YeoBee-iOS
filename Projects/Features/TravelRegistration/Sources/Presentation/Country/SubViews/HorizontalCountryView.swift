//
//  HorizontalCountryView.swift
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

class HorizontalContryView: UIScrollView {
    lazy var stackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 10
        $0.backgroundColor = .clear
        return $0
    }(UIStackView())
    private let dividerView = YBDivider(height: 0.6, color: .gray3)
    
    var selectedButton: UIButton?
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        configure()
        bind()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    // 버튼 탭하고 스크롤 가능하게!
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIButton {
            return true
        }
        return super.touchesShouldCancel(in: view)
    }
    
    private func setView() {
        canCancelContentTouches = true
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
    private func configure() {
        addSubview(stackView)
        addSubview(dividerView)
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        CountryType.allCases.forEach { type in
            let btn = YBPaddingButton(text: type.rawValue, padding: .small)
            
            btn.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.selectedButton?.isSelected = false
                    self?.selectedButton = btn
                    btn.isSelected.toggle()
                })
                .disposed(by: disposeBag)
            
            stackView.addArrangedSubview(btn)
            
            // 초기 selected 값
            if type == .total {
                btn.isSelected = true
                selectedButton = btn
            }
        }
    }
}
