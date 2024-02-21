//
//  TripCalculationViewController.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 2/21/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import RxSwift

import DesignSystem
import SnapKit
import ComposableArchitecture
import Coordinator
import Entity

public final class TripCalculationViewController: UIViewController {

    let coordinator: CalculationCoordinator

    // MARK: View

    private let tripCalculationHostingController: TripCalculationHostingController

    public init(coordinator: CalculationCoordinator, tripItem: TripItem) {

        self.coordinator = coordinator
        self.tripCalculationHostingController = TripCalculationHostingController(
            rootView: TripCalculationView(
                store: .init(initialState: .init(tripItem: tripItem), reducer: {
                    TripCalculationReducer()
                })
            )
        )
        super.init(nibName: nil, bundle: nil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setLayouts()
    }

    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        navigationController?.navigationBar.topItem?.title = "정산 영수증"

        view.backgroundColor = .ybColor(.gray1)
    }

    @objc func backButtonTapped() {
        coordinator.popDidFinish()
    }

    func setLayouts() {
        view.addSubview(tripCalculationHostingController.view)

        tripCalculationHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    deinit {
        print("ExpenditureViewController is de-initialized.")
    }
}
