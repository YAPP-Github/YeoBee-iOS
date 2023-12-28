//
//  TripDateCollectionView.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

final class TripDateCollectionView: UICollectionView {

    convenience init() {
        self.init(frame: .zero, collectionViewLayout: TripDateCollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        allowsMultipleSelection = false
        register(
            TripDateCell.self,
            forCellWithReuseIdentifier: TripDateCell.reuseIdentifier
        )
    }
}


