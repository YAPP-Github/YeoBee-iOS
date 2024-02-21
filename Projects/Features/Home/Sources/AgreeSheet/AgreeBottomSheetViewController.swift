//
//  AgreeBottomSheetViewController.swift
//  Home
//
//  Created by Hoyoung Lee on 2/22/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem
import Entity

public class AgreeBottomSheetViewController: YBBottomSheetViewController {

    let coordinator: CreateAccountCoordinator

    // MARK: View

    private let agreeSheetHostingController: AgreeSheetHostingController

    public init(
        coordinator: CreateAccountCoordinator
    ) {
        self.coordinator = coordinator
        self.agreeSheetHostingController = AgreeSheetHostingController(
            rootView: .init(
                store: .init(
                    initialState: .init(),
                    reducer: {
                        AgreeSheetReducer(coordinator: coordinator)
                    }
                )
            )
        )
        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        containerView.addSubview(agreeSheetHostingController.view)

        agreeSheetHostingController.view.snp.makeConstraints { make in
            make.top.trailing.leading.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
