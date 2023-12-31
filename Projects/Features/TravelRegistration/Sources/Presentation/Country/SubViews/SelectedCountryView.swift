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
        }
    }
    weak var selectedCountryViewDelegate: SelectedCountryViewDelegate?
    
    lazy var countryCollectionView = CountryCollectionView()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setLayouts()
        setCollectionViewDataSource()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented xib init")
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
    
    private func setCollectionViewDataSource() {
        countryCollectionView.dataSource = self
    }
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
