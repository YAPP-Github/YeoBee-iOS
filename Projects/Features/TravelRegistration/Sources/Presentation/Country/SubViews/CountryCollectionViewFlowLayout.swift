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
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
        itemSize = CGSize(width: 58, height: 68)
    }
}
