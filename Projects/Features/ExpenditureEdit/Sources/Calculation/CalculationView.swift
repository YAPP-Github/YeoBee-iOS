//
//  CalculationView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture

struct CalculationView: View {
    typealias State = CalculationReducer.State
    typealias Action = CalculationReducer.Action

    let store: StoreOf<CalculationReducer>

    var body: some View {
        Text("Hello world!")
    }
}
