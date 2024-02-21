//
//  MyPageReactor.swift
//  Mypage
//
//  Created by 김태형 on 2/15/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import Foundation
import ReactorKit
import UseCase
import Entity
import ComposableArchitecture

public final class MyPageReactor: Reactor {
    
    public enum Action {
        case nameButtonTapped
        case fetchUserInfo(FetchUserResponse)
    }
    
    public enum Mutation {
        case navigatoToEdit
        case fetchUserInfo(FetchUserResponse)
    }
    
    public struct State {
        var isNameButtonTapped: Bool = false
        var userInfo: FetchUserResponse? = nil
    }
    
    @Dependency(\.userInfoUseCase) var userInfoUseCase
    public var initialState: State
    
    public init() {
        self.initialState = State()
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
            case .nameButtonTapped:
                return Observable.just(Mutation.navigatoToEdit)
            case .fetchUserInfo(let userInfo):
                return .just(.fetchUserInfo(userInfo))
        }
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
            case .navigatoToEdit:
                newState.isNameButtonTapped = true
            case .fetchUserInfo(let userInfo):
                newState.userInfo = userInfo
        }
        return newState
    }
    
    func fetchUserInfo() {
        Task {
            let userInfo = try await userInfoUseCase.fetchUserInfo()
            self.action.onNext(.fetchUserInfo(userInfo))
        }
    }
    
    func tripDescription() -> String {
        switch currentState.userInfo?.tripCount ?? 0 {
        case 0...2:
            return "당신은 여비 입문중!"
        case 3...4:
            return "당신은 여비 완벽 적응중!"
        case 5:
            return "당신은 여비 관리 고수!"
        default:
            return "당신은 여비의 1등 총무"
        }
    }
}
