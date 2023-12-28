//
//  TripDateDiffableDataSource.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

public enum Expenditure: CaseIterable {
    case main
}

final class TripDateDataSource: UICollectionViewDiffableDataSource<Expenditure, String> { }

extension TripDateDataSource {
    func update(items: [String]) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        apply(snapshot)
    }
}
