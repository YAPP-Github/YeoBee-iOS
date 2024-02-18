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
import Entity

public final class ExpenditureAddViewController: UIViewController {

    let coordinator: ExpenditureAddCoordinator
    let store: StoreOf<ExpenditureReducer>
    let editDate: Date

    // MARK: View

    private let expenditureHostingController: ExpenditureAddHostingController

    public init(coordinator: ExpenditureAddCoordinator, tripItem: TripItem, editDate: Date, expenditureTab: ExpenditureTab) {
        self.coordinator = coordinator
        let store: StoreOf<ExpenditureReducer> = .init(
            initialState: .init(
                expenditureTab: expenditureTab,
                seletedExpenditureType: .expense,
                tripItem: tripItem,
                editDate: editDate
            ),
            reducer: {
                ExpenditureReducer(cooridinator: coordinator)
            }
        )
        self.store = store
        self.expenditureHostingController = ExpenditureAddHostingController(
            rootView: ExpenditureAddView(
                store: store
            )
        )
        self.editDate = editDate
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
        title = editDateFormatter.string(from: editDate)
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
            .withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
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

    var editDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "MM.dd(EE)"
        return dateFormatter
    }

    deinit {
        print("ExpenditureAddViewController deinit")
    }
}

extension ExpenditureAddViewController {
    func selectCurrency(currency: Currency, expenseType: ExpenseType?) {
        if case expenseType = .individual {
            store.send(.expenditureEdit(.expenditureInput(.setCurrency(currency))))
        } else if case expenseType = .individualBudget {
            store.send(.expenditureBudgetEdit(.expenditureInput(.setCurrency(currency))))
        }
    }

    func setCalculationData(expenseDetail: ExpenseDetailItem, expenseType: ExpenditureType) {
        store.send(.setCalculationData(expenseDetail, expenseType))
    }
}
