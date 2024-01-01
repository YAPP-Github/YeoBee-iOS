//
//  CountryReactor.swift
//  TravelRegistration
//
//  Created by 박현준 on 12/30/23.
//  Copyright © 2023 YeoBee.com. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

public final class CountryReactor: Reactor {
    
    public enum Action {
        case searchBarText(text: String)
        case typeButtonTapped(title: String)
        case checkedButtonTapped(country: Country)
        case deletedCountry(country: Country)
        case nextButtonTapped
    }
    
    public enum Mutation {
        case searchBarText(text: String)
        case typeButtonTapped(title: String)
        case checkedButtonTapped(country: Country)
        case deletedCountry(country: Country)
        case nextButtonTapped
    }
    
    public struct State {
        var countries: [Country] = []
        var selectedCountries: [Country] = []
        var deletedCountry: Country?
    }
    
    public var initialState: State = State()
    
    func viewDidLoad() {
        action.onNext(.typeButtonTapped(title: CountryType.total.rawValue))
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
        case .nextButtonTapped:
            return .just(Mutation.nextButtonTapped)
        }
    }
    
    // MARK: Reduce
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .searchBarText(text: let text):
            // 검색 api 받기
            print(text)
        case .typeButtonTapped(title: let title):
            // 데이터 api 받기
            switch title {
            case CountryType.total.rawValue:
                newState.countries = CountryType.total.getCountries()
            case CountryType.europe.rawValue:
                newState.countries = CountryType.europe.getCountries()
            case CountryType.asia.rawValue:
                newState.countries = CountryType.asia.getCountries()
            case CountryType.northAmerica.rawValue:
                newState.countries = CountryType.northAmerica.getCountries()
            case CountryType.southAmerica.rawValue:
                newState.countries = CountryType.southAmerica.getCountries()
            case CountryType.africa.rawValue:
                newState.countries = CountryType.africa.getCountries()
            default:
                break
            }
        case .checkedButtonTapped(country: let country):
            if let selectedCountryIndex = newState.selectedCountries.firstIndex(where: { $0.name == country.name }) {
                newState.selectedCountries.remove(at: selectedCountryIndex)
            } else {
                newState.selectedCountries.append(country)
            }
        case .deletedCountry(country: let country):
            if let selectedCountryIndex = newState.selectedCountries.firstIndex(where: { $0.name == country.name }) {
                newState.selectedCountries.remove(at: selectedCountryIndex)
            }
        case .nextButtonTapped:
            print("next 찍힘")
            break
        }
        return newState
    }
    
    func unSelectedCountry(country: Country) {
        let action = Action.deletedCountry(country: country)
        _ = self.mutate(action: action)
    }
}
