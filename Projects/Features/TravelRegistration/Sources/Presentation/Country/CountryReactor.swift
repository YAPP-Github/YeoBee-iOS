//
//  CountryReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ComposableArchitecture
import Entity
import UseCase
import ReactorKit
import RxSwift
import RxCocoa

public final class CountryReactor: Reactor {
    
    public enum Action {
        case searchBarText(text: String)
        case typeButtonTapped(title: String)
        case checkedButtonTapped(country: Country)
        case deletedCountry(country: Country)
        case initCountry(countryListResponse: CountryListResponse)
    }
    
    public enum Mutation {
        case searchBarText(text: String)
        case typeButtonTapped(title: String)
        case checkedButtonTapped(country: Country)
        case deletedCountry(country: Country)
        case initCountry(countryListResponse: CountryListResponse)
    }
    
    public struct State {
        var totalCountries: DataCountry = DataCountry(europe: [], asia: [], northAmerica: [], southAmerica: [], oceania: [], africa: [])
        var countries: DataCountry = DataCountry(europe: [], asia: [], northAmerica: [], southAmerica: [], oceania: [], africa: [])
        var selectedCountries: [Country] = []
        var makeLimitToast: Bool = false
    }
    
    @Dependency(\.countryUseCase) var countryUseCase
    public var initialState: State = State()
    
    func countriesUseCase() {
        Task {
            let result = try await countryUseCase.getCountries()
            action.onNext(.initCountry(countryListResponse: result))
        }
    }
    
    // MARK: - Mutate
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .searchBarText(text: let text):
            return .just(Mutation.searchBarText(text: text))
        case .typeButtonTapped(title: let title):
            return .just(Mutation.typeButtonTapped(title: title))
        case .checkedButtonTapped(country: let country):
            return .just(Mutation.checkedButtonTapped(country: country))
        case .deletedCountry(country: let country):
            return .just(Mutation.deletedCountry(country: country))
        case .initCountry(countryListResponse: let countryListReponse):
            return .just(.initCountry(countryListResponse: countryListReponse))
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .searchBarText(text: let searchText):
            newState.makeLimitToast = false
            let filteredEurope = state.totalCountries.europe.filter { $0.name.contains(searchText) }
            let filteredAsia = state.totalCountries.asia.filter { $0.name.contains(searchText) }
            let filteredNorthAmerica = state.totalCountries.northAmerica.filter { $0.name.contains(searchText) }
            let filteredSouthAmerica = state.totalCountries.southAmerica.filter { $0.name.contains(searchText) }
            let filteredOceania = state.totalCountries.oceania.filter { $0.name.contains(searchText) }
            let filteredAfrica = state.totalCountries.africa.filter { $0.name.contains(searchText) }

            newState.countries = DataCountry(
                europe: filteredEurope,
                asia: filteredAsia,
                northAmerica: filteredNorthAmerica,
                southAmerica: filteredSouthAmerica,
                oceania: filteredOceania,
                africa: filteredAfrica
            )
            if searchText.isEmpty {
                newState.countries = DataCountry(
                    europe: state.totalCountries.europe,
                    asia: state.totalCountries.asia,
                    northAmerica: state.totalCountries.northAmerica,
                    southAmerica: state.totalCountries.southAmerica,
                    oceania: state.totalCountries.oceania,
                    africa: state.totalCountries.africa)
            }
        case .typeButtonTapped(title: let title):
            newState.makeLimitToast = false
            switch title {
            case CountryType.total.rawValue:
                newState.countries = DataCountry(
                    europe: state.totalCountries.europe,
                    asia: state.totalCountries.asia,
                    northAmerica: state.totalCountries.northAmerica,
                    southAmerica: state.totalCountries.southAmerica,
                    oceania: state.totalCountries.oceania,
                    africa: state.totalCountries.africa)
            case CountryType.europe.rawValue:
                newState.countries = DataCountry(
                    europe: state.totalCountries.europe,
                    asia: [],
                    northAmerica: [],
                    southAmerica: [],
                    oceania: [],
                    africa: [])
            case CountryType.asia.rawValue:
                newState.countries = DataCountry(
                    europe: [],
                    asia: state.totalCountries.asia,
                    northAmerica: [],
                    southAmerica: [],
                    oceania: [],
                    africa: [])
            case CountryType.northAmerica.rawValue:
                newState.countries = DataCountry(
                    europe: [],
                    asia: [],
                    northAmerica: state.totalCountries.northAmerica,
                    southAmerica: [],
                    oceania: [],
                    africa: [])
            case CountryType.southAmerica.rawValue:
                newState.countries = DataCountry(
                    europe: [],
                    asia: [],
                    northAmerica: [],
                    southAmerica: state.totalCountries.southAmerica,
                    oceania: [],
                    africa: [])
            case CountryType.oceania.rawValue:
                newState.countries = DataCountry(
                    europe: [],
                    asia: [],
                    northAmerica: [],
                    southAmerica: [],
                    oceania: state.totalCountries.oceania,
                    africa: [])
            case CountryType.africa.rawValue:
                newState.countries = DataCountry(
                    europe: [],
                    asia: [],
                    northAmerica: [],
                    southAmerica: [],
                    oceania: [],
                    africa: state.totalCountries.africa)
            default:
                break
            }
        case .checkedButtonTapped(country: let country):
            newState.makeLimitToast = false
            if let selectedCountryIndex = newState.selectedCountries.firstIndex(where: { $0.name == country.name }) {
                newState.selectedCountries.remove(at: selectedCountryIndex)
            } else {
                if newState.selectedCountries.count >= 20 {
                    newState.makeLimitToast = true
                    break
                }
                newState.selectedCountries.append(country)
            }
        case .deletedCountry(country: let country):
            if let selectedCountryIndex = newState.selectedCountries.firstIndex(where: { $0.name == country.name }) {
                newState.selectedCountries.remove(at: selectedCountryIndex)
                newState.makeLimitToast = false
            }
        case .initCountry(countryListResponse: let countryListResponse):
            var newTotalCountries = DataCountry(
                europe: [],
                asia: [],
                northAmerica: [],
                southAmerica: [],
                oceania: [],
                africa: []
            )
            
            for country in countryListResponse.countryList.values.flatMap({ $0 }) {
                switch country.continent {
                case CountryType.europe.rawValue:
                    newTotalCountries.europe.append(Country(name: country.name, imageURL: country.flagImageUrl ?? ""))
                case CountryType.asia.rawValue:
                    newTotalCountries.asia.append(Country(name: country.name, imageURL: country.flagImageUrl ?? ""))
                case CountryType.northAmerica.rawValue:
                    newTotalCountries.northAmerica.append(Country(name: country.name, imageURL: country.flagImageUrl ?? ""))
                case CountryType.southAmerica.rawValue:
                    newTotalCountries.southAmerica.append(Country(name: country.name, imageURL: country.flagImageUrl ?? ""))
                case CountryType.oceania.rawValue:
                    newTotalCountries.oceania.append(Country(name: country.name, imageURL: country.flagImageUrl ?? ""))
                case CountryType.africa.rawValue:
                    newTotalCountries.africa.append(Country(name: country.name, imageURL: country.flagImageUrl ?? ""))
                default:
                    break
                }
            }
            newState.totalCountries = newTotalCountries
            newState.countries = newTotalCountries
        }
        return newState
    }
    
    func unSelectedCountry(country: Country) {
        let action = Action.deletedCountry(country: country)
        _ = self.mutate(action: action)
    }
}
