//
//  CurrencyBottomSheetViewController.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem
import Entity

public class CurrencyBottomSheetViewController: YBBottomSheetViewController {

    let coordinator: ExpenditureAddCoordinator

    // MARK: View

    private let currencyBottomSheetHostingController: CurrencyBottomSheetHostingController

    public init(
        coordinator: ExpenditureAddCoordinator,
        currenyList: [Currency]
//        selectedCurrency: Currency
    ) {
        self.coordinator = coordinator
        self.currencyBottomSheetHostingController = CurrencyBottomSheetHostingController(
            rootView: .init(
                store: .init(
                    initialState: .init(currencyList: currenyList),
                    reducer: {
                        CurrencySheetReducer(cooridinator: coordinator)
                    }
                )
            )
        )
        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        containerView.addSubview(currencyBottomSheetHostingController.view)

        currencyBottomSheetHostingController.view.snp.makeConstraints { make in
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
