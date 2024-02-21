//
//  MyPageViewController.swift
//  Trip
//
//  Created by Hoyoung Lee
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

import DesignSystem
import Repository

public class MyPageViewController: UIViewController, View {
    
    public var disposeBag = DisposeBag()
    public var coordinator: MyPageCoordinator?
    private let reactor = MyPageReactor()
    
    private let supportMenus = ["공지사항", "문의하기", "버전 정보"]
    private let supportMenuURLs = ["https://m.cafe.naver.com/ca-fe/web/cafes/31153021/menus/7","https://m.cafe.naver.com/ca-fe/web/cafes/31153021/menus/1"]
    private let termsMenus = ["개인정보 처리방침", "이용약관"]
    private let termsMenuURLs = ["https://m.cafe.naver.com/ca-fe/web/cafes/yeobee/articles/2?useCafeId=false&tc", "https://m.cafe.naver.com/ca-fe/web/cafes/31153021/articles/6?fromList=true&menuId=10&tc=cafe_article_list"]
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let myInfoContentView = UIView()
    private let proposeContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let myPageMenuTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 10
        tableView.clipsToBounds = true
        return tableView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 28
        //TODO: 프로필 이미지 기능 추가시 아래 이미지 수정
        imageView.image = DesignSystemAsset.Icons.face0.image
        return imageView
    }()
    
    private let nameButton = MyPageProfileButton(frame: CGRect(x: 0, y: 0, width: 81, height: 30), nickname: "")
    private let tripDescriptionLabel = YBLabel(font: .body2, textColor: .gray6)
    private let tripLabel = YBLabel(text: "여행", font: .body3, textColor: .gray4)
    private let tripCountLabel = YBLabel(font: .body3, textColor: .mainGreen)
    
    private let proposeTitleLabel = YBLabel(text: "여러분의 목소리에\n귀를 기울이고 있어요!", font: .body2)
    private var proposeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = YBColor.brightGreen.color
        button.layer.cornerRadius = 16
        button.setTitle("의견 제안하기", for: .normal)
        button.setTitleColor(YBColor.mainGreen.color, for: .normal)
        button.titleLabel?.font = YBFont.body3.font
        return button
    }()
    
    private var proposeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = DesignSystemAsset.Icons.proposeImage.image
        return imageView
    }()
    
    override public func viewWillAppear(_ animated: Bool) {
        reactor.fetchUserInfo()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        myPageMenuTableView.dataSource = self
        myPageMenuTableView.delegate = self
        navigationController?.isNavigationBarHidden = false
        
        view.backgroundColor = YBColor.gray1.color
        bind(reactor: reactor)
        setupViews()
        setLayouts()
        configureBar()
        nameButton.onTap = { [weak self] in
            let editProfileVC = EditMyProfileViewController()
            let reactor = EditMyProfileReactor(userInfo: self?.reactor.currentState.userInfo)
            editProfileVC.reactor = reactor
            self?.navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(reactor: MyPageReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindAction(reactor: MyPageReactor) {
        
    }
    
    func bindState(reactor: MyPageReactor) {
        reactor.state.map { $0.userInfo?.nickname }
            .filter { $0 != nil }
            .bind { [weak self] nickname in
                DispatchQueue.main.async {
                    self?.nameButton.nickname = nickname ?? ""
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.userInfo?.tripCount }
            .bind { [weak self] tripCount in
                DispatchQueue.main.async {
                    self?.tripCountLabel.text = "\(tripCount ?? 0)개국"
                    self?.tripDescriptionLabel.text = reactor.tripDescription()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureBar() {
        let backImage = UIImage(systemName: "chevron.backward")?.withTintColor(YBColor.gray5.color, renderingMode: .alwaysOriginal)
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = "MY"
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func proposeButtonTapped() {
        let urlString = "https://m.cafe.naver.com/ca-fe/web/cafes/31153021/menus/8"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = YBColor.gray1.color
        myPageMenuTableView.register(MyPageMenuCell.self, forCellReuseIdentifier: MyPageMenuCell().reuseableIdentifier)
        myPageMenuTableView.separatorStyle = .none
        
        myInfoContentView.backgroundColor = .white
        nameButton.setTitle(reactor.currentState.userInfo?.nickname, for: .normal)
        
        proposeTitleLabel.numberOfLines = 0
        proposeTitleLabel.setLineHeight(lineHeight: 22.5)
        
        myPageMenuTableView.isScrollEnabled = false
        
        proposeButton.addTarget(self, action: #selector(proposeButtonTapped), for: .touchUpInside)
    }
    
    private func setLayouts() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(myInfoContentView)
        contentView.addSubview(proposeContentView)
        contentView.addSubview(myPageMenuTableView)
        
        myInfoContentView.addSubview(profileImageView)
        myInfoContentView.addSubview(nameButton)
        myInfoContentView.addSubview(tripDescriptionLabel)
        myInfoContentView.addSubview(tripLabel)
        myInfoContentView.addSubview(tripCountLabel)
        
        proposeContentView.addSubview(proposeTitleLabel)
        proposeContentView.addSubview(proposeButton)
        proposeContentView.addSubview(proposeImageView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.width.equalTo(scrollView.snp.width)
        }
        
        myInfoContentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(128)
            make.directionalHorizontalEdges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(56)
        }
        
        nameButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(myInfoContentView.snp.trailing).offset(-24)
            make.height.equalTo(30)
        }
        
        tripDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameButton.snp.bottom).offset(4)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(myInfoContentView.snp.trailing).offset(-24)
            make.height.equalTo(23)
        }
        
        tripLabel.snp.makeConstraints { make in
            make.top.equalTo(tripDescriptionLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.height.equalTo(21)
        }
        
        tripCountLabel.snp.makeConstraints { make in
            make.top.equalTo(tripLabel.snp.top)
            make.leading.equalTo(tripLabel.snp.trailing).offset(8)
            make.height.equalTo(tripLabel.snp.height)
        }
        
        proposeContentView.snp.makeConstraints { make in
            make.top.equalTo(myInfoContentView.snp.bottom).offset(20)
            make.height.equalTo(128)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        proposeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(proposeContentView.snp.top).offset(20)
            make.leading.equalTo(proposeContentView.snp.leading).offset(24)
        }
        
        proposeButton.snp.makeConstraints { make in
            make.top.equalTo(proposeTitleLabel.snp.bottom).offset(11)
            make.leading.equalTo(proposeTitleLabel.snp.leading)
            make.width.equalTo(99)
            make.height.equalTo(30)
        }
        
        proposeImageView.snp.makeConstraints { make in
            make.top.equalTo(proposeContentView.snp.top).offset(20)
            make.trailing.equalTo(proposeContentView.snp.trailing).offset(-24)
            make.size.equalTo(86)
        }
        
        myPageMenuTableView.snp.makeConstraints { make in
            make.top.equalTo(proposeContentView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(460)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(22)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(56)
        }
    }
}

extension MyPageViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 4개의 섹션
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "고객지원"
            case 1: return "서비스 약관"
            default: return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return supportMenus.count
            case 1: return termsMenus.count
            default: return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageMenuCell().reuseableIdentifier, for: indexPath) as? MyPageMenuCell else {
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            cell.titleLabel.text = supportMenus[indexPath.row]
            if indexPath.row == 3 {
                cell.nextImageView.isHidden = true
                cell.versionLabel.isHidden = false
                cell.isUserInteractionEnabled = false
            } else {
                cell.nextImageView.isHidden = false
                cell.versionLabel.isHidden = true
                cell.isUserInteractionEnabled = true
            }
        } else {
            cell.titleLabel.text = termsMenus[indexPath.row]
        }
        return cell
    }
}

extension MyPageViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 100.0 : 0.0 // 버튼 2개를 위한 충분한 높이 설정
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 1 else { return nil }
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
        footerView.backgroundColor = .white
        
        let logoutButton = UIButton(type: .system)
        logoutButton.frame = CGRect(x: 20, y: 10, width: 56, height: 40)
        logoutButton.setTitle("로그아웃", for: .normal)
        logoutButton.setTitleColor(YBColor.gray5.color, for: .normal)
        logoutButton.titleLabel?.font = YBFont.body3.font
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        let revokeButton = UIButton(type: .system)
        revokeButton.frame = CGRect(x: 20, y: 50, width: 56, height: 40)
        revokeButton.setTitle("회원탈퇴", for: .normal)
        revokeButton.setTitleColor(YBColor.gray5.color, for: .normal)
        revokeButton.titleLabel?.font = YBFont.body3.font
        revokeButton.addTarget(self, action: #selector(revokeButtonTapped), for: .touchUpInside)
        
        footerView.addSubview(logoutButton)
        footerView.addSubview(revokeButton)
        
        return footerView
    }
    
    @objc func logoutButtonTapped() {
        let popupController = YBPopupTypeViewController(popupType: .logout)
        popupController.delegate = self
        self.presentPopup(presentedViewController: popupController)
    }
    
    @objc func revokeButtonTapped() {
        coordinator?.revoke()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 선택 효과 제거
        
        var urlString = ""
        if indexPath.section == 0 { // 고객지원 섹션
            urlString = supportMenuURLs[indexPath.row]
        } else if indexPath.section == 1 { // 서비스 약관 섹션
            urlString = termsMenuURLs[indexPath.row]
        }
        
        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension MyPageViewController: YBPopupViewControllerDelegate {
    public func cancelButtonTapped() {
        return
    }
    
    public func actionButtonTapped() {
        TokenRepository.shared.deleteTokens()
        coordinator?.login()
    }
}
