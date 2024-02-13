//
//  TotalBudgetExpenditureViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture
import Coordinator

public final class TotalBudgetExpenditureViewController: UIViewController {

    let coordinator: ExpenditureCoordinator
    let expenseType: ExpenditureTab

    // MARK: View

    private let totalBudgetHostingController: TotalBudgetHostingController

//    // MARK: DataSources

    public init(coordinator: ExpenditureCoordinator, expenseType: ExpenditureTab) {

        self.coordinator = coordinator
        self.expenseType = expenseType
        self.totalBudgetHostingController = TotalBudgetHostingController(
            rootView: TotalBudgetExpenditureListView(
                store: .init(initialState: .init(expenseType: expenseType), reducer: {
                    TotalBudgetExpenditureListReducer(cooridinator: coordinator)
                })
            )
        )
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
        setupViews()
        setLayouts()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        title = expenseType == .individual ? "예산 잔액 내역" : "공동경비 잔액 내역"
        view.backgroundColor = .ybColor(.white)
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.back.image
            .withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        coordinator.popDidFinish()
    }

    func setLayouts() {
        view.addSubview(totalBudgetHostingController.view)

        totalBudgetHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    deinit {
        print("ExpenditureViewController is de-initialized.")
    }
}

