//
//  SettingCurrencyViewController.swift
//  Setting
//
//  Created by 박현준 on 2/12/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import Entity
import ReactorKit
import SnapKit
import RxSwift
import RxCocoa

public final class SettingCurrencyViewController: UIViewController {
    
    public var disposeBag = DisposeBag()
    private let reactor: SettingCurrencyReactor
    
    // MARK: - Properties
    private let titleLabel = YBLabel(text: "적용된 환율", font: .header2, textColor: .black)
    private let subtitleLabel = YBLabel(text: "수정 시 지정 환율로 계산됩니다.", font: .body2, textColor: .gray5)
    private let settingCurrencyView = SettingCurrencyView()
    private var modifyButton = YBTextButton(text: "수정하기",
                                          appearance: .defaultDisable,
                                          size: .medium)
    
    // MARK: - Life Cycles
    public init(reactor: SettingCurrencyReactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        addViews()
        setLayouts()
        configureBar()
        bind(reactor: reactor)
        bindKeyboardNotification()
    }
    
    // MARK: - Set UI
    private func setView() {
        view.backgroundColor = .white
        title = "환율 설정"
    }
    
    private func addViews() {
        [
            titleLabel,
            subtitleLabel,
            settingCurrencyView,
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
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-6)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        settingCurrencyView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).inset(-16)
            make.leading.equalTo(subtitleLabel.snp.leading)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(50)
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
        print("SettingCurrencyViewController is de-initialized.")
    }
}

// MARK: - Bind
extension SettingCurrencyViewController: View {
    public func bind(reactor: SettingCurrencyReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: SettingCurrencyReactor) {
        settingCurrencyView.wonCurrencyTextField.rx.text
            .map { Reactor.Action.textFieldText(text: $0 ?? "") }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        modifyButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                print("환율 수정")
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: SettingCurrencyReactor) {
        reactor.state
            .map { $0.currency }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] currency in
                self?.settingCurrencyView.defaultCurrencyLabel.text = currency.code
                self?.settingCurrencyView.wonCurrencyTextField.placeholder = "\(currency.value)"
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.textFieldText }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] text in
                if text.isEmpty {
                    self?.modifyButton.isEnabled = false
                    self?.modifyButton.setTitle("수정하기", for: .normal)
                    self?.modifyButton.setAppearance(appearance: .defaultDisable)
                } else {
                    self?.modifyButton.isEnabled = true
                    self?.modifyButton.setTitle("수정하기", for: .normal)
                    self?.modifyButton.setAppearance(appearance: .default)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Keyboard 처리
extension SettingCurrencyViewController {
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
extension SettingCurrencyViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == modifyButton {
            return false
        }
        return true
    }
}
