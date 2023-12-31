//
//  CountryCollectionView.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/31/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

final class CountryCollectionView: UICollectionView {

    convenience init() {
        self.init(frame: .zero, collectionViewLayout: CountryCollectionViewFlowLayout())
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)

        setupView()
    }
    
    private func setupView() {
        showsHorizontalScrollIndicator = false
        contentInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        register(SelectedCountryCell.self, forCellWithReuseIdentifier: SelectedCountryCell.identifier)
    }
}
