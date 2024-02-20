//
//  EditMyProfileReactor.swift
//  MyPage
//
//  Created by 김태형 on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

import Repository
import YBNetwork
import Entity

public final class EditMyProfileReactor: Reactor {
    public enum Action  {
        case editButtonTapped
        case updateNickname(String)
    }
    
    public enum Mutation {
        case setNicknameEmpty(Bool)
        case setNickname(String, Bool)
        case setErrorMessage(String?)
    }
    
    public struct State {
        @Pulse var isNicknameEmpty: Bool
        var nickname: String
        var errorMessage: String?
        var userInfo: FetchUserResponse?
    }
    
    public let initialState: State
    
    public init(userInfo: FetchUserResponse?) {
        self.initialState = .init(
            isNicknameEmpty: true,
            nickname: "",
            userInfo: userInfo
        )
    }
    
    let userInfoRepository = UserInfoRepository()
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .updateNickname(let nickname):
                return Observable.just(Mutation.setNickname(nickname, nickname.isEmpty))
            case .editButtonTapped:
                return Observable.create { observer in
                    if let errorMessage = self.isValidNickname(self.currentState.nickname) {
                        observer.onNext(.setErrorMessage(errorMessage))
                    } else {
                        observer.onNext(.setErrorMessage(nil))
                        Task { @MainActor in
                            try await self.updateUserInfo()
                        }
                    }
                    return Disposables.create()
                }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
            case .setNicknameEmpty(let isEmpty):
                newState.isNicknameEmpty = isEmpty
            case .setNickname(let nickname, let isEmpty):
                newState.nickname = nickname
                newState.isNicknameEmpty = isEmpty
            case .setErrorMessage(let message):
                newState.errorMessage = message
        }
        return newState
    }
    
    private func isValidNickname(_ nickname: String) -> String? {
        if !NSPredicate(format: "SELF MATCHES %@", "^[가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9]+$").evaluate(with: nickname) {
            return "특수문자 사용이 불가해요."
        }
        if nickname.count > 5 {
            return "한글, 영문 포함 5자 이내로 입력해주세요."
        }
        return nil
    }
    
    private func updateUserInfo() async throws -> Void {
        let nickname = currentState.nickname
        let request = UpdateUserInfoRequest(nickname: nickname)
        try await userInfoRepository.updateUserInfo(request: request)
    }
}
