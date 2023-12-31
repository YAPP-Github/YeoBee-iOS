//
//  HomeCollectionViewFlowLayout.swift
//  Home
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit

final class HomeCollectionViewFlowLayout: UICollectionViewFlowLayout {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init() {
        super.init()

        setupView()
    }

    private func setupView() {
        scrollDirection = .vertical
        minimumLineSpacing = 20
        minimumInteritemSpacing = 20
        sectionInset = .init(top: 20, left: 0, bottom: 30, right: 0)
    }
}
