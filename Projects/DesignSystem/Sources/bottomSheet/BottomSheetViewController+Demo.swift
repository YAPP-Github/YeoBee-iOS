//
//  YBSelectBottomSheetViewController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class TestBottomSheetViewController: YBBottomSheetViewController {
    
    public let button: UIButton = {
        let button = UIButton()
        button.setTitle("bottomSheet", for: .normal)
        button.backgroundColor = .orange
        return button
    }()
    
    public let button1: UIButton = {
        let button = UIButton()
        button.setTitle("bottomSheet", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.addSubview(button)
        containerView.addSubview(button1)
        
        button.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        button1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(30)
            make.top.equalTo(button.snp.bottom).offset(5)
        }
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
