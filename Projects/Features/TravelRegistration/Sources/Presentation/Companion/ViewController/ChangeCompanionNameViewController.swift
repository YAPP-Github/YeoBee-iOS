//
//  ChangeCompanionNameViewController.swift
//  TravelRegistration
//
//  Created by 박현준 on 1/13/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import SnapKit
import RxSwift
import RxCocoa

protocol ChangeCompanionNameViewControllerDelegate: AnyObject {
    func changedCompanionName(index: IndexPath, tripUserItemRequest: TripUserItemRequest)
}

public final class ChangeCompanionNameViewController: UIViewController {

    public var disposeBag = DisposeBag()
    private let reactor: ChangeCompanionNameReactor
    weak var delegate: ChangeCompanionNameViewControllerDelegate?
    
    // MARK: - Properties
    private let titleLabel = YBLabel(text: "이름 변경", font: .header2, textColor: .black)
    private let nameTextField = YBTextField(backgroundColor: .gray1)
    private let effectivenessLabel = YBLabel(text: "",font: .body4, textColor: .mainRed)
    private var modifyButton = YBTextButton(text: "수정하기",
                                          appearance: .defaultDisable,
                                          size: .medium)
    
    // MARK: - Life Cycles
    public init(reactor: ChangeCompanionNameReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setView()
        addViews()
        setLayouts()
        configureBar()
        bindKeyboardNotification()
        bind(reactor: reactor)
    }
    
    // MARK: - Set UI
    private func setView() {
        title  = "동행자 이름 수정"
    }
    
    private func addViews() {
        [
            titleLabel,
            nameTextField,
            effectivenessLabel,
            modifyButton
        ].forEach {
            view.addSubview($0)
        }
        
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.leading.equalToSuperview().inset(24)
        }
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-14)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        effectivenessLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).inset(-10)
            make.leading.equalTo(nameTextField.snp.leading)
            make.trailing.equalTo(nameTextField.snp.trailing)
        }
        modifyButton.snp.makeConstraints { make in
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
        print("deinit ChangeCompanionNameViewController")
    }
}

// MARK: - Bind
extension ChangeCompanionNameViewController: View {
    public func bind(reactor: ChangeCompanionNameReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: ChangeCompanionNameReactor) {
        nameTextField.rx.text
            .map { Reactor.Action.nameTextFieldText(text: $0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        modifyButton.rx.tap
            .bind { [weak self] _ in
                if let name = self?.reactor.currentState.limitedString,
                   let index = self?.reactor.currentState.index,
                   let imageUrl = self?.reactor.currentState.tripUserItemRequest.profileImageUrl {
                    let tripUserItemRequest = TripUserItemRequest(name: name, profileImageUrl: imageUrl)
                    
                    self?.delegate?.changedCompanionName(index: index, tripUserItemRequest: tripUserItemRequest)
                    self?.navigationController?.popViewController(animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
    func bindState(reactor: ChangeCompanionNameReactor) {
        reactor.state
            .map { $0.tripUserItemRequest }
            .bind { [weak self] tripUserItemRequest in
                self?.nameTextField.placeholder = tripUserItemRequest.name
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.limitedString }
            .bind(to: nameTextField.rx.text )
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.effectivenessType }
            .bind { [weak self] type in
                switch type {
                case .none:
                    self?.effectivenessLabel.text = ""
                    self?.modifyButton.isEnabled = false
                    self?.modifyButton.setTitle("수정하기", for: .normal)
                    self?.modifyButton.setAppearance(appearance: .defaultDisable)
                case .notValid:
                    self?.effectivenessLabel.text = "한글/영문 포함 5자까지 입력 가능해요."
                    self?.modifyButton.isEnabled = false
                    self?.modifyButton.setTitle("수정하기", for: .normal)
                    self?.modifyButton.setAppearance(appearance: .defaultDisable)
                case .containSpecialCharacters:
                    self?.effectivenessLabel.text = "특수문자는 사용이 불가해요."
                    self?.modifyButton.isEnabled = false
                    self?.modifyButton.setTitle("수정하기", for: .normal)
                    self?.modifyButton.setAppearance(appearance: .defaultDisable)
                case .valid:
                    self?.effectivenessLabel.text = ""
                    self?.modifyButton.isEnabled = true
                    self?.modifyButton.setTitle("수정하기", for: .normal)
                    self?.modifyButton.setAppearance(appearance: .default)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Keyboard 처리
extension ChangeCompanionNameViewController {
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
                self.modifyButton.snp.updateConstraints { make in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(10)
                }
            } else {
                self.modifyButton.snp.updateConstraints { make in
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
extension ChangeCompanionNameViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == modifyButton {
            return false
        }
        return true
    }
}
