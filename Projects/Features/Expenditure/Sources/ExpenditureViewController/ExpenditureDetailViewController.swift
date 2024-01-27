//
//  ExpenditureDetailViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 1/28/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture
import Coordinator

public final class ExpenditureDetailViewController: UIViewController {

    let coordinator: ExpenditureCoordinator

    // MARK: View

    private let expenditureDetailHostingController: ExpenditureDetailHostingController

    public init(coordinator: ExpenditureCoordinator, expenseItem: ExpenseItem) {

        self.coordinator = coordinator
        self.expenditureDetailHostingController = ExpenditureDetailHostingController(
            rootView: ExpenditureDetailView(
                store: .init(
                    initialState: .init(expenseItem: expenseItem),
                    reducer: {
                        ExpenditureDetailReducer(cooridinator: coordinator)
                    }
                )
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
        title = "지출 상세"
        view.backgroundColor = .ybColor(.white)
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.back.image
            .withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        coordinator.popDidFinish()
    }

    func setLayouts() {
        view.addSubview(expenditureDetailHostingController.view)

        expenditureDetailHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    deinit {
        print("ExpenditureDetailViewController is de-initialized.")
    }
}

