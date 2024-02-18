//
//  OnboardingViewController.swift
//  Onboarding
//
//  Created by 이호영 on
//

import UIKit
import ReactorKit
import Coordinator
import DesignSystem
import SnapKit
import RxCocoa

public final class OnboardingViewController: UIViewController {
    let coordinator: OnboardingCoordinator

    // MARK: View

    private let onboardingSheetHostingController: OnboardingSheetHostingController

    public init(
        coordinator: OnboardingCoordinator
    ) {
        self.coordinator = coordinator
        self.onboardingSheetHostingController = OnboardingSheetHostingController(
            rootView: .init(
                store: .init(
                    initialState: .init(),
                    reducer: {
                        OnboardingReducer(coordinator: coordinator)
                    }
                )
            )
        )
        super.init()
    }


    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
