//
//  DividerViewController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public class DividerViewController: DesignSystemBaseViewController {
    
    let gray3Divider = YBDivider(height: 1, color: .gray3)
    let gray2Divider = YBDivider(height: 1, color: .gray2)
    let gray3LargeDivider = YBDivider(height: 10, color: .gray3)
    let gray2LargeDivider = YBDivider(height: 10, color: .gray2)
    let dotDivider = YBDivider(.dotLine, height: 1, color: .gray4)
    
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
        
        stackView.addArrangedSubview(gray3Divider)
        stackView.addArrangedSubview(gray2Divider)
        stackView.addArrangedSubview(gray3LargeDivider)
        stackView.addArrangedSubview(gray2LargeDivider)
        stackView.addArrangedSubview(dotDivider)
    }
}
