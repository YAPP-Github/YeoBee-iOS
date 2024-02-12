//
//  CurrencyTextFieldView.swift
//  ExpenditureEdit
//
//  Created by Hoyoung Lee on 1/6/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import SwiftUI
import Combine
import DesignSystem

struct CurrencyTextFieldView: View {
    @FocusState private var isFocused: Bool
    @Binding var text: String
    private let placeholder: String
    private let characterLimit: Int = 10
    private let alertAction: () -> Void

    public init(
        text: Binding<String>,
        placeholder: String,
        alertAction: @escaping () -> Void
    ) {
        self._text = text
        self.placeholder = placeholder
        self.alertAction = alertAction
    }

    var body: some View {
        ZStack(alignment: .leading) {
            placeholderView
            TextField("", text: $text)
                .keyboardType(.decimalPad)
                .focused($isFocused)
                .foregroundColor(.ybColor(.black))
                .font(.ybfont(.header1))
                .onReceive(Just(text), perform: { newValue in
                    let numbers = "0123456789"
                    let decimalSeperator: String = Locale.current.decimalSeparator ?? "."
                    if newValue.components(separatedBy: decimalSeperator).count-1 == 1 {
                        if newValue.last == "." {
                            self.text = newValue
                        } else {
                            let filtered = newValue.replacingOccurrences(of: ",", with: "")
                            let splitNumber = filtered.split(separator: ".")
                            if let digits = splitNumber.first,
                               let point = splitNumber.last,
                               point.count > 2 {
                                let number = Double(digits+"."+point.dropLast())
                                self.text = number?.formattedWithSeparator ?? ""
                            } else {
                                self.text = newValue
                            }
                        }
                    } else if newValue.components(separatedBy: decimalSeperator).count-1 > 1 {
                        let filtered = newValue.replacingOccurrences(of: ",", with: "")
                        let number = Double(String(filtered.dropLast()))
                        self.text = number?.formattedWithSeparator ?? ""
                    } else {
                        let filterd = newValue.filter { numbers.contains($0) }
                        if filterd != newValue {
                            let numberString = filterd.replacingOccurrences(of: ",", with: "")
                            if numberString.count > 11 {
                                let number = Double(numberString.dropLast())
                                self.text = number?.formattedWithSeparator ?? ""
                                alertAction()
                            } else {
                                let number = Double(numberString)
                                self.text = number?.formattedWithSeparator ?? ""
                            }
                        } else {
                            if newValue.count > 11 {
                                let number = Double(newValue.dropLast())
                                self.text = number?.formattedWithSeparator ?? ""
                                alertAction()
                            } else {
                                let number = Double(newValue)
                                self.text = number?.formattedWithSeparator ?? ""
                            }
                        }
                    }
                }
            )
        }
    }
}

extension CurrencyTextFieldView  {
    private var placeholderView: some View {
        Text(placeholder)
            .foregroundColor(.ybColor(.gray4))
            .font(.ybfont(.header1))
            .opacity(text.isEmpty ? 1 : 0)
    }
}
