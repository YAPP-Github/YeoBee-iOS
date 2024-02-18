//
//  ExpenditureCalculationDirectView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 2/16/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture

struct ExpenditureCalculationDirectView: View {
    typealias State = ExpenditureCalculationDirectReducer.State
    typealias Action = ExpenditureCalculationDirectReducer.Action

    let store: StoreOf<ExpenditureCalculationDirectReducer>

    var body: some View {
        Text("Hello world!")
    }
}
