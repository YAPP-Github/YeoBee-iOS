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
import Entity

public final class ExpenditureDetailViewController: UIViewController {

    let coordinator: ExpenditureCoordinator
    let expenseType: ExpenditureTab
    let expenseItem: ExpenseItem
    let store: StoreOf<ExpenditureDetailReducer>
    var isEdit: Bool = false

    // MARK: View

    private let expenditureDetailHostingController: ExpenditureDetailHostingController

    public init(coordinator: ExpenditureCoordinator, expenseType: ExpenditureTab, expenseItem: ExpenseItem, hasSharedBudget: Bool) {
        self.expenseType = expenseType
        self.expenseItem = expenseItem
        self.coordinator = coordinator
        let store: StoreOf<ExpenditureDetailReducer> = .init(
            initialState: .init(expenditureTab: expenseType, expenseItem: expenseItem, hasSharedBudget: hasSharedBudget),
            reducer: {
                ExpenditureDetailReducer(cooridinator: coordinator)
            }
        )
        self.store = store
        self.expenditureDetailHostingController = ExpenditureDetailHostingController(
            rootView: ExpenditureDetailView(store: store)
        )
        super.init(nibName: nil, bundle: nil)
    }

    @Dependency(\.expenseUseCase) var expenseUseCase

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
        title = expenseItem.category == .income ? expenseType == .individual ? "내 예산 상세" : "공동경비 상세" : "지출 상세"
        view.backgroundColor = .ybColor(.white)
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.back.image
            .withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        let deleteImage = DesignSystemAsset.Icons.trash.image
            .withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let deleteButton = UIBarButtonItem(image: deleteImage, style: .plain, target: self, action: #selector(deleteButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = deleteButton
    }

    @objc func backButtonTapped() {
        if isEdit {
            coordinator.popDetail()
            isEdit = false
        } else {
            coordinator.popDidFinish()
        }
    }

    @objc func deleteButtonTapped() {
        Task {
            do {
                let _ = try await expenseUseCase.deleteExpense(expenseItem.id)

                await MainActor.run {
                    coordinator.popDetail()
                }
            } catch {
                print(error)
            }
        }
    }

    func setLayouts() {
        view.addSubview(expenditureDetailHostingController.view)

        expenditureDetailHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    public func setUpdateExpenditureDetail(expenseItem: ExpenseItem) {
        isEdit = true
        store.send(.setExpenseItem(expenseItem))
    }

    deinit {
        print("ExpenditureDetailViewController is de-initialized.")
    }
}

