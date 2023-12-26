//
//  ButtonViewController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public class ButtonViewController: DesignSystemBaseViewController {
    
    let defaultLargeButton = YBTextButton(text: "디폴트 버튼이애옹", appearance: .default, size: .large)
    let defaultMediumButton = YBTextButton(text: "디폴트 버튼이애옹", appearance: .default, size: .medium)
    let defaultDisableLargeButton = YBTextButton(text: "디폴트 비활성화 버튼이애옹", appearance: .defaultDisable, size: .large)
    let defaultDisableMediumButton = YBTextButton(text: "디폴트 비활성화 버튼이애옹", appearance: .defaultDisable, size: .medium)
    let selectLargeButton = YBTextButton(text: "셀렉트 버튼이애옹", appearance: .select, size: .large)
    let selectMediumButton = YBTextButton(text: "셀렉트 버튼이애옹", appearance: .select, size: .medium)
    let selectSmallButton = YBTextButton(text: "셀렉트 버튼이애옹", appearance: .select, size: .small)
    let selectDisableLargeButton = YBTextButton(text: "셀렉트 비활성화 버튼이애옹", appearance: .selectDisable, size: .large)
    let selectDisableMediumButton = YBTextButton(text: "셀렉트 비활성화 버튼이애옹", appearance: .selectDisable, size: .medium)
    let selectDisableSmallButton = YBTextButton(text: "셀렉트 비활성화 버튼이애옹", appearance: .selectDisable, size: .small)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Button"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public override func setupView() {
        super.setupView()
        
        stackView.addArrangedSubview(defaultLargeButton)
        stackView.addArrangedSubview(defaultMediumButton)
        stackView.addArrangedSubview(defaultDisableLargeButton)
        stackView.addArrangedSubview(defaultDisableMediumButton)
        stackView.addArrangedSubview(selectLargeButton)
        stackView.addArrangedSubview(selectMediumButton)
        stackView.addArrangedSubview(selectSmallButton)
        stackView.addArrangedSubview(selectDisableLargeButton)
        stackView.addArrangedSubview(selectDisableMediumButton)
        stackView.addArrangedSubview(selectDisableSmallButton)
    }
}

