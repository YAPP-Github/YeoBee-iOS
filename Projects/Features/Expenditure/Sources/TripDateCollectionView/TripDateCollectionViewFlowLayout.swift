//
//  TripDateCollectionViewFlowLayout.swift
//  Expenditure
//
//  Created by Hoyoung Lee on 12/27/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

final class TripDateCollectionViewFlowLayout: UICollectionViewFlowLayout {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init() {
        super.init()

        setupView()
    }

    private func setupView() {
        scrollDirection = .horizontal
    }
}
