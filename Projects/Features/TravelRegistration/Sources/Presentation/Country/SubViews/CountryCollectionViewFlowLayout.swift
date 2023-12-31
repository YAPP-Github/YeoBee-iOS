//
//  CountryCollectionViewFlowLayout.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/31/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

final class CountryCollectionViewFlowLayout: UICollectionViewFlowLayout {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init() {
        super.init()

        setupView()
    }

    private func setupView() {
        scrollDirection = .horizontal
        minimumLineSpacing = 15
        minimumInteritemSpacing = 15
        itemSize = CGSize(width: 80, height: 65)
    }
}
