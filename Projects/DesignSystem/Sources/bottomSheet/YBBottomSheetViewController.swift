//
//  YBBottomSheetViewController.swift
//  DesignSystem
//
//  Created by 이호영 on 2023/12/25.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

open class YBBottomSheetViewController: UIViewController {

    fileprivate let sheetContentView = UIView()
    fileprivate let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ybColor(.gray3)
        return view
    }()
    public let containerView = UIView()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setViews()
        setContraints()
    }
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setContraints() {
        view.addSubview(sheetContentView)
        sheetContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-50)
        }
        
        sheetContentView.addSubview(indicatorView)
        sheetContentView.addSubview(containerView)
        indicatorView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(4)
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(indicatorView).offset(24)
            make.bottom.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
        }
    }
    
    public func setViews() {
        view.backgroundColor = .clear
        
        sheetContentView.backgroundColor = .white
        sheetContentView.layer.cornerRadius = 20
    }
}
