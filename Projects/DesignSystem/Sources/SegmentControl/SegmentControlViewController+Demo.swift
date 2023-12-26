//
//  SegmentControlViewController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit

public class SegmentControlViewController: DesignSystemBaseViewController {
    
    let ybRoundSegmentControl = YBSegmentControl(.round, items: ["공동", "개인"])
    let ybRectangleSegmentControl = YBSegmentControl(.rectangle ,items: ["지출 추가", "공동 경비 추가"])
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "segmentControl"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        stackView.addArrangedSubview(ybRoundSegmentControl)
        stackView.addArrangedSubview(ybRectangleSegmentControl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

