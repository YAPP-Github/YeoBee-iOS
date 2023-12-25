//
//  TextFieldViewController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/24.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

public class TextFieldViewController: DesignSystemBaseViewController {
    
    public let ybTextfield1: YBTextField = {
        let textfield = YBTextField()
        textfield.setPlaceholder("입력해주세요.")
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "TextField"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    public override func setupView() {
        super.setupView()
        
        stackView.addArrangedSubview(ybTextfield1)
    }
}

