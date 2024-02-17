//
//  SettingRecycleViewController.swift
//  Setting
//
//  Created by 박현준 on 2/10/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import TravelRegistration
import Entity
import ReactorKit
import SnapKit
import RxSwift
import RxCocoa

public final class SettingRecycleViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: SettingRecycleReactor
    weak var delegate: ModifiedSettingViewControllerDelegate?
    
    // MARK: - Properties
    private let titleLabel = YBLabel(font: .header2, textColor: .black)
    private let nameOrTitleTextField = YBTextField(backgroundColor: .gray1)
    private let effectivenessLabel = YBLabel(text: "",font: .body4, textColor: .mainRed)
    private var modifyButton = YBTextButton(text: "수정하기",
                                          appearance: .defaultDisable,
                                          size: .medium)
    
    // MARK: - Life Cycles
    public init(reactor: SettingRecycleReactor) {
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
        bind(reactor: reactor)
        bindKeyboardNotification()
    }
    
    // MARK: - Set UI
    private func addViews() {
        [
            titleLabel,
            nameOrTitleTextField,
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
        nameOrTitleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-14)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
        }
        effectivenessLabel.snp.makeConstraints { make in
            make.top.equalTo(nameOrTitleTextField.snp.bottom).inset(-10)
            make.leading.equalTo(nameOrTitleTextField.snp.leading)
            make.trailing.equalTo(nameOrTitleTextField.snp.trailing)
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
        print("SettingRecycleViewController is de-initialized.")
    }
}

// MARK: - Bind
extension SettingRecycleViewController: View {
    public func bind(reactor: SettingRecycleReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingRecycleReactor) {
        nameOrTitleTextField.rx.text
            .map { Reactor.Action.textFieldText(text: $0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        modifyButton.rx.tap
            .bind { [weak self] _ in
                guard let self else { return }
                if self.reactor.currentState.viewType == .companionName {
                    self.reactor.modifyCompanionNameUseCase()
                } else if self.reactor.currentState.viewType == .tripTitle {
                    self.reactor.modifyTitleUseCase()
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SettingRecycleReactor) {
        reactor.state
            .map { $0.limitedString }
            .bind(to: nameOrTitleTextField.rx.text)
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
                    if self?.reactor.currentState.viewType == .companionName {
                        self?.effectivenessLabel.text = "한글/영문 포함 5자까지 입력 가능해요."
                    } else if self?.reactor.currentState.viewType == .tripTitle {
                        self?.effectivenessLabel.text = "한글/영어/특수문자 포함 15자까지 입력 가능해요."
                    }
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
        
        reactor.state
            .map { $0.viewType }
            .bind { [weak self] viewType in
                switch viewType {
                case .tripTitle:
                    self?.titleLabel.text = "여행 제목을 수정해주세요."
                    self?.nameOrTitleTextField.placeholder = self?.reactor.currentState.tripItem.title
                case .companionName:
                    self?.title = "동행자 이름 수정"
                    self?.titleLabel.text = "이름 변경"
                    self?.nameOrTitleTextField.placeholder = self?.reactor.currentState.tripUserItem?.name
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.modified }
            .bind { [weak self] isSuccess in
                if isSuccess {
                    self?.delegate?.modified()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Keyboard 처리
extension SettingRecycleViewController {
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
extension SettingRecycleViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == modifyButton {
            return false
        }
        return true
    }
}
