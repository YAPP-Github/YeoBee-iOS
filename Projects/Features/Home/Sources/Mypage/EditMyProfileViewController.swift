//
//  EditMyProfileViewController.swift
//  MyPage
//
//  Created by 김태형 on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import Coordinator
import ReactorKit
import RxSwift
import RxCocoa

import DesignSystem
import SnapKit

public final class EditMyProfileViewController: UIViewController, View {
    public var disposeBag: DisposeBag = DisposeBag()
    //TODO: 프로필 이미지 기능 추가시 아래 이미지 수정
    let profileImageView = UIImageView(image: DesignSystemAsset.Icons.face0.image)
    let nameLabel = YBLabel(text: "이름", font: .title1)
    let linkedAccountLabel = YBLabel(text: "연결된 계정", font: .title1)
    let nicknameTextField = YBTextField()
    let socialTypeIamgeView = UIImageView()
    let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        return view
    }()
    let socialTypeLabel = YBLabel(font: .title1)
    let errorDescriptionLabel = YBLabel(text: "", font: .body4, textColor: .mainRed)
    let editButton = YBTextButton(text: "수정하기", appearance: .defaultDisable, size: .medium)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setSocialImage()
        setLayouts()
        configureBar()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(reactor: EditMyProfileReactor) {
        //Action
        nicknameTextField.rx.text.orEmpty
            .map { Reactor.Action.updateNickname($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        editButton.rx.tap
            .map { Reactor.Action.editButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //State
        reactor.pulse(\.$isNicknameEmpty)
            .bind { [weak self] isNicknameEmpty in
                if isNicknameEmpty {
                    self?.editButton.setAppearance(appearance: .defaultDisable)
                    self?.editButton.setTitle("수정하기", for: .normal)
                    self?.editButton.isEnabled = false
                } else {
                    self?.editButton.setAppearance(appearance: .default)
                    self?.editButton.setTitle("수정하기", for: .normal)
                    self?.editButton.isEnabled = true
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .bind { [weak self] errorMessage in
                self?.errorDescriptionLabel.text = errorMessage
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isEditSuccess } //TODO: updateUserInfo 2번 호출되는문제 해결 필요
            .distinctUntilChanged()
            .bind { [weak self] isSuccess in
                if isSuccess {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "내 정보"
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setSocialImage() {
        guard let socialType = reactor?.currentState.userInfo?.authProviderType else {
            return
        }
        if socialType == .kakao {
            socialTypeIamgeView.image = DesignSystemAsset.Icons.kakao.image
            socialTypeLabel.text = "카카오"
            circleView.backgroundColor = DesignSystemAsset.Colors.kakaoYellow.color
        } else {
            socialTypeIamgeView.image = DesignSystemAsset.Icons.apple.image
            socialTypeLabel.text = "Apple"
            circleView.backgroundColor = .black
        }
    }
    
    private func setupViews() {
        view.backgroundColor = YBColor.white.color
        nicknameTextField.placeholder = reactor?.currentState.userInfo?.nickname
        nicknameTextField.textColor = .black
        nicknameTextField.becomeFirstResponder()
    }
    
    private func setLayouts() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(nicknameTextField)
        view.addSubview(editButton)
        view.addSubview(errorDescriptionLabel)
        view.addSubview(linkedAccountLabel)
        view.addSubview(socialTypeLabel)
        view.addSubview(circleView)
        view.addSubview(socialTypeIamgeView)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(102)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.height.equalTo(50)
            make.width.equalTo(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.equalTo(nameLabel.snp.trailing).offset(57)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        errorDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        linkedAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(errorDescriptionLabel.snp.bottom).offset(30)
            make.leading.equalTo(nameLabel.snp.leading)
            make.height.equalTo(30)
        }
        
        socialTypeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(socialTypeIamgeView)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        circleView.snp.makeConstraints { make in
            make.top.equalTo(linkedAccountLabel.snp.top)
            make.trailing.equalTo(socialTypeLabel.snp.leading).offset(-10)
            make.size.equalTo(30)
        }
        
        socialTypeIamgeView.snp.makeConstraints { make in
            make.top.equalTo(linkedAccountLabel.snp.top)
            make.trailing.equalTo(socialTypeLabel.snp.leading).offset(-10)
            make.size.equalTo(30)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-68)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
    }
}
