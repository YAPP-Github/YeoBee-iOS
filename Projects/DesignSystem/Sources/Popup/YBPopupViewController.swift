//
//  YBPopupViewController.swift
//  DesignSystem
//
//  Created by Hoyoung Lee on 2/9/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public class YBPopupViewController: UIViewController {

    fileprivate let sheetContentView = UIView()
    fileprivate let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .ybColor(.gray3)
        return view
    }()
    public let containerView = UIView()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setViews()
        setContraints()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setContraints() {
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
            make.top.equalTo(indicatorView).offset(28)
            make.trailing.equalToSuperview().offset(-24)
            make.leading.equalToSuperview().offset(24)
            make.bottom.equalToSuperview().offset(-50)
        }
    }

    public func setViews() {
        view.backgroundColor = .clear

        sheetContentView.backgroundColor = .white
        sheetContentView.layer.cornerRadius = 20
    }
}

