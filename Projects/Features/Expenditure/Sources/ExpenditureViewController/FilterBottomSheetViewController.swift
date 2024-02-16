//
//  FilterBottomSheetViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import UIKit
import DesignSystem
import Entity

public class FilterBottomSheetViewController: YBBottomSheetViewController {

    let coordinator: ExpenditureCoordinator

    // MARK: View

    private let filterBottomSheettHostingController: FilterBottomSheettHostingController

    public init(
        coordinator: ExpenditureCoordinator,
        selectedExpenseFilter: PaymentMethod?
    ) {
        self.coordinator = coordinator
        self.filterBottomSheettHostingController = FilterBottomSheettHostingController(
            rootView: .init(
                store: .init(
                    initialState: .init(
                        selectedExpenseFilter: selectedExpenseFilter
                    ),
                    reducer: {
                        FilterBottomSheetReducer(cooridinator: coordinator)
                    }
                )
            )
        )
        super.init()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        containerView.addSubview(filterBottomSheettHostingController.view)

        filterBottomSheettHostingController.view.snp.makeConstraints { make in
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
