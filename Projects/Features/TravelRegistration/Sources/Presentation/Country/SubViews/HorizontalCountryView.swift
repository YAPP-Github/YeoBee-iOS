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

class HorizontalCountryView: UIScrollView {
    // MARK: - Properties
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
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        addViews()
        setLayout()
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
    
    //MARK: - Set UI
    private func setView() {
        canCancelContentTouches = true
        showsHorizontalScrollIndicator = false
        bounces = false
    }
    
    private func addViews() {
        addSubview(stackView)
        addSubview(dividerView)
    }
    private func setLayout() {
        stackView.snp.makeConstraints { make in
            make.top.bottom.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    func bind() {
        CountryType.allCases.forEach { type in
            let btn = YBPaddingButton(text: type.rawValue, borderColor: .gray3, isGradient: false, padding: .medium)
            
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
    
    func totalButtonTapped() {
        if let totalButton = stackView.arrangedSubviews.first(where: { ($0 as? UIButton)?.title(for: .normal) == CountryType.total.rawValue }) as? UIButton {
            totalButton.rx.tap
                .subscribe(onNext: { [weak self] in
                    self?.selectedButton?.isSelected = false
                    self?.selectedButton = totalButton
                    totalButton.isSelected.toggle()
                    
                    // scrollView contentOffset을 제일 좌측으로 변경
                    self?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                })
                .disposed(by: disposeBag)
            totalButton.sendActions(for: .touchUpInside)
        }
    }
}
