//
//  TotalExpenditureViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 1/27/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture
import Coordinator

public final class TotalExpenditureViewController: UIViewController {

    let coordinator: ExpenditureCoordinator

    // MARK: View

    private let totalExpenditureListHostingController: TotalExpenditureListHostingController

//    // MARK: DataSources

    public init(coordinator: ExpenditureCoordinator) {

        self.coordinator = coordinator
        self.totalExpenditureListHostingController = TotalExpenditureListHostingController(
            rootView: TotalExpenditureListView(
                store: .init(initialState: .init(), reducer: {
                    TotalExpenditureListReducer()
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
        title = "총쓴돈 내역"
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
        view.addSubview(totalExpenditureListHostingController.view)

        totalExpenditureListHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    deinit {
        print("ExpenditureViewController is de-initialized.")
    }
}
