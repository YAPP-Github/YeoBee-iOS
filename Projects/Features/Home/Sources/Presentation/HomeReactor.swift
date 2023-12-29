//
//  HomeReactor.swift
//  Home
//
//  Created by 박현준 on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

public class HomeReactor: Reactor {
    
    var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeDataItem>!
    var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeDataItem>()
    
    public enum Action {
        
    }
    
    public enum Mutation {
        
    }
    
    public struct State {
        
    }
    
    public var initialState: State = State()
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        
    }
    
    // MARK: - Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        
        return newState
    }
    
    func configureSnapshot(comingData: [Trip], passedData: [Trip]) {
        snapshot.appendSections([.header, .coming, .passed])
        // [TODO] 헤더 데이터 값 추가
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems(comingData.map { .coming($0) }, toSection: .coming)
        snapshot.appendItems(passedData.map { .passed($0) }, toSection: .passed)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
