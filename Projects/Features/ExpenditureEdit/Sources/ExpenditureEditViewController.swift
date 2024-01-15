//
//  ExpenditureEditViewController.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee 
//

import UIKit
import DesignSystem
import SnapKit
import ComposableArchitecture

public final class ExpenditureEditViewController: UIViewController {

    let coordinator: ExpenditureEditCoordinator

    // MARK: View

    private let expenditureHostingController: ExpenditureAddHostingController

    public init(coordinator: ExpenditureEditCoordinator) {

        self.coordinator = coordinator
        self.expenditureHostingController = ExpenditureAddHostingController(
            rootView: ExpenditureAddView(
                store: .init(
                    initialState: .init(seletedExpenditureType: .shared),
                    reducer: {
                        ExpenditureReducer()
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
        title = "일본 여행"
        view.backgroundColor = .ybColor(.gray1)
    }

    func setLayouts() {
        view.addSubview(expenditureHostingController.view)

        expenditureHostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
    }

    func setNavigationBar() {
        let backImage = DesignSystemAsset.Icons.delete.image
            .withTintColor(YBColor.black.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }

    @objc func backButtonTapped() {
        coordinator.coordinatorDidFinish()
    }

    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        navigationController?.view.endEditing(true)
    }
}
