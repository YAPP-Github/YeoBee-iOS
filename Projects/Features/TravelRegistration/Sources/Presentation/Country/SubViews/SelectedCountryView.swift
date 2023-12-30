//
//  SelectedCountryView.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import DesignSystem
import SnapKit

protocol SelectedCountryViewDelegate: AnyObject {
    func deleteCountry(country: Country)
}

class SelectedCountryView: UIScrollView {
    // MARK: - Properties
    var selectedCountries: [Country] = [] {
        didSet {
            countryCollectionView.reloadData()
//            checkedNextButtonVaild()
        }
    }
    weak var selectedCountryViewDelegate: SelectedCountryViewDelegate?
    
    lazy var countryCollectionView: UICollectionView = {
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 15, bottom: 0, right: 15)
        $0.dataSource = self
        $0.register(SelectedCountryCell.self, forCellWithReuseIdentifier: SelectedCountryCell.identifier)
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: setCollectionViewFlowLayout()))
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setLayouts()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
    }
    
    private func setCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.itemSize = CGSize(width: 80, height: 80)
        return layout
    }

    private func addViews() {
        addSubview(countryCollectionView)
    }
    
    private func setLayouts() {
        countryCollectionView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalToSuperview()
        }
    }
    
//    private func checkedNextButtonVaild() {
//        if selectedCountries.isEmpty {
//            nextButton.backgroundColor = .systemGray4
//            nextButton.setTitleColor(.darkGray, for: .normal)
//            nextButton.isEnabled = false
//        } else {
//            nextButton.backgroundColor = .black
//            nextButton.setTitleColor(.white, for: .normal)
//            nextButton.isEnabled = true
//        }
//    }
}

// MARK: - CollectionView DataSource
extension SelectedCountryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.selectedCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedCountryCell.identifier, for: indexPath) as! SelectedCountryCell
        let country = selectedCountries[indexPath.row]
        cell.delegate = self
        cell.country = country
        return cell
    }
}

// MARK: - Delegate
extension SelectedCountryView: SelectedCountryCellDelegate {
    func deleteButtonTapped(country: Country) {
        selectedCountryViewDelegate?.deleteCountry(country: country)
    }
}
