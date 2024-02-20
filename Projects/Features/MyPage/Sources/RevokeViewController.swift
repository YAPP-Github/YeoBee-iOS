//
//  RevokeViewController.swift
//  MyPage
//
//  Created by 김태형 on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import ReactorKit
import RxCocoa

final class RevokeViewController: UIViewController, View {
    public var disposeBag: DisposeBag = DisposeBag()
    
    let titleLabel = YBLabel(text: "여비를 탈퇴하시기 전 확인해주세요.", font: .header2)
    let hStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    let warningImageView = UIImageView()
    let warningTitleLabel = YBLabel(text: "회원 탈퇴시 유의사항", font: .body2)
    let warningDescriptionLabel = YBLabel(text: "- 사용하신 계정 정보는 회원 탈퇴 후 모두 삭제되며, 삭제된 데이터는 복구가 불가합니다.\n\n- 현재 로그인된 아이디는 즉시 탈퇴 처리되며, 탈퇴 후 회원님의 정보는 전자상거래 소비자보호법에 의거한 여비 개인정보처리방침 및 서비스 이용약관에 따라 관리됩니다.",font: .body3)
    let confirmDescriptionLabel = YBLabel(text: "위 사항을 모두 숙지했고, 탈퇴에 동의합니다.", font: .body1)
    let checkButton = UIButton()
    let revokeButton = YBTextButton(text: "탈퇴하기", appearance: .defaultDisable, size: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureBar()
        setupViews()
        setLayouts()
    }
    
    public func bind(reactor: RevokeViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: RevokeViewReactor) {
        checkButton.rx.tap
            .map { Reactor.Action.toggleCheckButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindState(reactor: RevokeViewReactor) {
        reactor.state.map { $0.isCheckButtonChecked }
            .subscribe(onNext: { [weak self] isChecked in
                self?.changeButtons(isChecked: isChecked)
                self?.revokeButton.isEnabled = isChecked
            })
            .disposed(by: disposeBag)
    }
    
    private func changeButtons(isChecked: Bool) {
        if isChecked {
            self.checkButton.setImage(DesignSystemAsset.Icons.checkedwithcircle.image, for: .normal)
            self.revokeButton.setAppearance(appearance: .default)
        } else {
            self.checkButton.setImage(DesignSystemAsset.Icons.uncheckwithcircle.image, for: .normal)
            self.revokeButton.setAppearance(appearance: .defaultDisable)
        }
    }
    
    private func setupViews() {
        warningDescriptionLabel.numberOfLines = 0
        warningDescriptionLabel.lineBreakMode = .byCharWrapping
        
        warningImageView.image = DesignSystemAsset.Icons.warningwithcircle.image
        checkButton.setImage(DesignSystemAsset.Icons.uncheckwithcircle.image, for: .normal)
    }
    
    private func setLayouts() {
        view.addSubview(titleLabel)
        view.addSubview(hStackView)
        
        hStackView.addArrangedSubview(warningImageView)
        hStackView.addArrangedSubview(warningTitleLabel)
        hStackView.setCustomSpacing(6, after: warningImageView)
        
        view.addSubview(warningDescriptionLabel)
        view.addSubview(confirmDescriptionLabel)
        view.addSubview(checkButton)
        view.addSubview(revokeButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(22)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(24)
        }
        hStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(24)
        }
        warningImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
        }
        warningDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(hStackView.snp.bottom).offset(16)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-24)
        }
        confirmDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(24)
            make.bottom.equalTo(revokeButton.snp.top).offset(-40)
        }
        checkButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-27)
            make.centerY.equalTo(confirmDescriptionLabel.snp.centerY)
        }
        revokeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(38)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(24)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-24)
        }
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "회원탈퇴"
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
