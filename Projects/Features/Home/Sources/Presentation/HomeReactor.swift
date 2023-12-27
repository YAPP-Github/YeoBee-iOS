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
    
    var dataSource: UICollectionViewDiffableDataSource<HomeSection, Trip>!
    
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
    
    func configureSnapshot(data: [Trip]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, Trip>()
        snapshot.appendSections([.main])
        snapshot.appendItems(data, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
