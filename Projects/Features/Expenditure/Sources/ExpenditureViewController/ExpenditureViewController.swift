//
//  ExpenditureListViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/26/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture
import Coordinator
import Entity

public final class ExpenditureViewController: UIViewController {

    let coordinator: ExpenditureCoordinator
    let store: StoreOf<ExpenditureReducer>
    let tripItem: TripItem

    // MARK: View

    private let expenditureHostingController: ExpenditureHostingController

    @Dependency(\.tripUseCase) var tripUseCase

    private var getTripItemTask: Task<Void, Never>?

    public init(coordinator: ExpenditureCoordinator, tripItem: TripItem) {
        self.coordinator = coordinator
        self.tripItem = tripItem
        let store: StoreOf<ExpenditureReducer> = .init(
            initialState: .init(type: .individual, tripItem: tripItem),
            reducer: {
                ExpenditureReducer(cooridinator: coordinator)
            })
        self.store = store
        self.expenditureHostingController = ExpenditureHostingController(
            rootView: ExpenditureView(
                store: store
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
        title = tripItem.title
        navigationController?.tabBarItem.title = "가계부"
        navigationController?.tabBarItem.image = DesignSystemAsset.Icons.accountBook.image
        navigationController?.toolbar.barTintColor = YBColor.black.color
        view.backgroundColor = .ybColor(.gray1)
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.delete.image
            .withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        let setImage = DesignSystemAsset.Icons.set.image
            .withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let setButton = UIBarButtonItem(image: setImage, style: .plain, target: self, action: #selector(setButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = setButton
    }

    @objc func backButtonTapped() {
        coordinator.coordinatorDidFinish()
    }

    @objc func setButtonTapped() {
        coordinator.tripSetting()
    }

    func setLayouts() {
        view.addSubview(expenditureHostingController.view)

        expenditureHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    public func getExpenseList(editDate: Date) {
        store.send(.getExpenseList(editDate))
    }

    func selectExpenseFilter(selectedExpenseFilter: PaymentMethod?) {
        store.send(.setExpenseFilter(selectedExpenseFilter))
    }

    public func setRefreshData() {
        store.send(.refresh)
    }

    public func getTripItem() {
        getTripItemTask = Task {
            do {
                let tripItem = try await tripUseCase.getTrip(tripItem.id)
                title = tripItem.title
                store.send(.setTripItem(tripItem))
                store.send(.refresh)
                coordinator.setTripItem(tripItem: tripItem)
            } catch {
                print(error)
            }
        }
    }

    deinit {
        getTripItemTask?.cancel()
        print("ExpenditureViewController is de-initialized.")
    }
}
