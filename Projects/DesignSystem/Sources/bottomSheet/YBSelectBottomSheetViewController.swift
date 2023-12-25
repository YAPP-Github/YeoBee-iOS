//
//  YBSelectBottomSheetViewController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import FlexLayout
import PinLayout

public class YBSelectBottomSheetViewController: BottomSheetPresentationController {
    
    public let button: UIButton = {
        let button = UIButton()
        button.setTitle("bottomSheet", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.flex.direction(.column).define { flex in
            flex.addItem(button)
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
