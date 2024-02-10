//
//  CreateAccountViewController.swift
//  Sign
//
//  Created by 김태형 on 2/8/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator
import ReactorKit
import RxSwift
import RxCocoa

import DesignSystem
import SnapKit

public final class CreateAccountViewController: UIViewController, View {
    public var disposeBag: DisposeBag = DisposeBag()
    public weak var coordinator: CreateAccountCoordinator?
    
    let nicknameLabel = YBLabel(text: "닉네임을 입력해주세요", font: .header2)
    let nicknameTextField = YBTextField()
    let errorDescriptionLabel = YBLabel(text: "", font: .body4, textColor: .mainRed)
    let confirmButton = YBTextButton(text: "시작하기", appearance: .selectDisable, size: .medium)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setLayouts()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(reactor: CreateAccountReactor) {
        //Action
        nicknameTextField.rx.text.orEmpty
            .map { Reactor.Action.updateNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
                .map { Reactor.Action.confirmButtonTapped }
                .bind(to: reactor.action)
                .disposed(by: disposeBag)
        
        //State
        reactor.state.map { $0.isNicknameEmpty }
            .bind { isNicknameEmpty in
                if isNicknameEmpty {
                    self.confirmButton.setAppearance(appearance: .defaultDisable)
                    self.confirmButton.isEnabled = false
                    self.confirmButton.setTitle("시작하기", for: .normal)
                } else {
                    self.confirmButton.setAppearance(appearance: .default)
                    self.confirmButton.isEnabled = true
                    self.confirmButton.setTitle("시작하기", for: .normal)
                }
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
                .bind { [weak self] errorMessage in
                    self?.errorDescriptionLabel.text = errorMessage
                }
                .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        view.backgroundColor = YBColor.white.color
        nicknameTextField.placeholder = "한글,영어 5자 이내 입력가능"
        nicknameTextField.textColor = .black
        nicknameTextField.becomeFirstResponder()
    }
    
    private func setLayouts() {
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(confirmButton)
        view.addSubview(errorDescriptionLabel)
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.right.equalTo(view.snp.right).offset(-24)
        }
        errorDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-68)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.right.equalTo(view.snp.right).offset(-24)
        }
    }
}

