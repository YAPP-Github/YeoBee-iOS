//
//  TravelTitleViewController.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/24/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import SnapKit
import RxSwift
import RxCocoa

public final class TravelTitleViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: TravelTitleReactor
    private let coordinator: TravelRegistrationCoordinator
    
    // MARK: - Properties
    private let titleLabel = YBLabel(text: "여행 제목을 입력해주세요.", font: .header2, textColor: .black)
    private let optionalLabel = YBLabel(text: "(선택)", font: .header2, textColor: .gray4)
    private let titleTextField = YBTextField(backgroundColor: .gray1)
    private let effectivenessLabel = YBLabel(text: "",font: .body4, textColor: .mainRed)
    private var makeTravelButton = YBTextButton(text: "여행만들기",
                                          appearance: .defaultDisable,
                                          size: .medium)
    
    // MARK: - Life Cycles
    init(coordinator: TravelRegistrationCoordinator ,reactor: TravelTitleReactor) {
        self.coordinator = coordinator
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViews()
        setLayouts()
        configureBar()
        bindKeyboardNotification()
        bind(reactor: reactor)
        setView()
    }
    
    // MARK: - Set UI
    private func setView() {
        guard let countryName = reactor.currentState.tripRequest.countryList.first?.name else { return }

        if titleTextField.text?.isEmpty == true {
            titleTextField.text = "\(countryName) 여행"
            reactor.action.onNext(.titleTextFieldText(text: "\(countryName) 여행"))
        }
    }
    
    private func addViews() {
        [
            titleLabel,
            optionalLabel,
            titleTextField,
            effectivenessLabel,
            makeTravelButton
        ].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(24)
        }
        optionalLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.leading.equalTo(titleLabel.snp.trailing)
        }
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-14)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        effectivenessLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).inset(-10)
            make.leading.equalTo(titleTextField.snp.leading)
            make.trailing.equalTo(titleTextField.snp.trailing)
        }
        makeTravelButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("deinit TravelTitleViewController")
    }
}

// MARK: - Bind
extension TravelTitleViewController: View {
    public func bind(reactor: TravelTitleReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: TravelTitleReactor) {
        titleTextField.rx.text
            .map { Reactor.Action.titleTextFieldText(text: $0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        makeTravelButton.rx.tap
            .bind { [weak self] _ in
                guard let self,
                      let titleString = self.titleTextField.text else { return }
                
                reactor.action.onNext(.makeTravelButtonTapped(text: titleString))
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: TravelTitleReactor) {
        reactor.state
            .map { $0.isValidTitleText }
            .bind { [weak self] isValid in
                if isValid {
                    self?.effectivenessLabel.text = ""
                    self?.makeTravelButton.isEnabled = true
                    self?.makeTravelButton.setTitle("여행 만들기", for: .normal)
                    self?.makeTravelButton.setAppearance(appearance: .default)
                } else {
                    self?.effectivenessLabel.text = "한글/영문/특수문자 포함 15까지 입력 가능해요."
                    self?.makeTravelButton.isEnabled = false
                    self?.makeTravelButton.setTitle("여행 만들기", for: .normal)
                    self?.makeTravelButton.setAppearance(appearance: .defaultDisable)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.postValidation }
            .bind { [weak self] isSuccess in
                if isSuccess {
                    self?.navigationController?.dismiss(animated: true)
                    self?.coordinator.coordinatorDidFinish()
                } else {
                    print("post 실패")
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Keyboard 처리
extension TravelTitleViewController {
    private func bindKeyboardNotification() {
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillShowNotification)
            .withUnretained(self)
            .bind { [weak self] (this, notification) in
                if let userInfo = notification.userInfo,
                   let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardFrame = keyboardFrameValue.cgRectValue
                    let keyboardHeight = keyboardFrame.size.height
                    self?.changeModifyButtonLayout(keyboardHeight: keyboardHeight)
                }
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx
            .notification(UIResponder.keyboardWillHideNotification)
            .withUnretained(self)
            .bind { [weak self] _ in
                self?.changeModifyButtonLayout(keyboardHeight: 0)
            }
            .disposed(by: disposeBag)
        
        hideKeyboardWhenTappedAround()
    }
    
    private func changeModifyButtonLayout(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0) {
            if keyboardHeight == 0 {
                self.makeTravelButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
                }
            } else {
                self.makeTravelButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight)
                }
            }
        }
        self.view.layoutIfNeeded()
    }
    
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        navigationController?.view.endEditing(true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension TravelTitleViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == makeTravelButton {
            return false
        }
        return true
    }
}
