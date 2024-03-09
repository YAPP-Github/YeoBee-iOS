//
//  CalculationViewController.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 2/18/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit
import ComposableArchitecture
import Entity

public final class CalculationViewController: UIViewController {

    let coordinator: ExpenditureAddCoordinator
    let editDate: Date = Date()

    // MARK: View

    private let calculationHostingController: CalculationHostingController

    public init(
        coordinator: ExpenditureAddCoordinator,
        expenseType: ExpenditureType,
        tripItem: TripItem,
        expenseDetail: ExpenseDetailItem,
        hasSharedBudget: Bool,
        selectCurrency: Currency
    ) {
        self.coordinator = coordinator
        self.calculationHostingController = CalculationHostingController(
            rootView: .init(
                store: .init(
                    initialState: .init(
                        expenseType: expenseType,
                        tripItem: tripItem,
                        expenseDetail: expenseDetail,
                        selectedPayer: nil,
                        hasSharedBudget: hasSharedBudget,
                        selectCurrency: selectCurrency
                    ),
                    reducer: {
                        ExpenditureCalculationReducer(coordinator: coordinator)
                    }
                )
            )
        )
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setLayouts()
        setNavigationBar()
        hideKeyboardWhenTappedAround()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        title = "정산 방법"
        view.backgroundColor = .ybColor(.gray1)
    }

    func setLayouts() {
        view.addSubview(calculationHostingController.view)

        calculationHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
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

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        navigationController?.view.endEditing(true)
    }

    deinit {
        print("CalculationViewController deinit")
    }
}
