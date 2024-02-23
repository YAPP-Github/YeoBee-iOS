//
//  ExpenditureDetailView.swift
//  Expenditure
//
//  Created Hoyoung Lee on 1/27/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Entity

final class ExpenditureDetailHostingController: UIHostingController<ExpenditureDetailView> {
}

struct ExpenditureDetailView: View {
    typealias State = ExpenditureDetailReducer.State
    typealias Action = ExpenditureDetailReducer.Action

    let store: StoreOf<ExpenditureDetailReducer>

    var body: some View {
        containerView
    }
}

extension ExpenditureDetailView {
    var containerView: some View {
        WithViewStore(store, observe: \.expenseItem) { viewStore in
            VStack(spacing: 0) {
                totalExpandPriceView(
                    price: Int(viewStore.amount),
                    convertedPrice: viewStore.koreanAmount,
                    currency: viewStore.currency
                )
                .padding(.all, 24)
                Rectangle()
                    .frame(height: 10)
                    .foregroundColor(.ybColor(.gray1))
                expenditureInfoView(expenseItem: viewStore.state)
                    .padding(.all, 24)
                Spacer()
                editButtonView
            }
            .onAppear { viewStore.send(.onAppear) }
        }
    }

    func totalExpandPriceView(price: Int, convertedPrice: Int?, currency: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("금액")
                .foregroundColor(.ybColor(.gray6))
                .font(.ybfont(.body3))
            Text(abs(price).formattedWithSeparator + " " + currency)
                .foregroundColor(.ybColor(.black))
                .font(.ybfont(.header1))
            if let convertedPrice {
                Text("= " + abs(convertedPrice).formattedWithSeparator + "원")
                    .foregroundColor(.ybColor(.gray4))
                    .font(.ybfont(.body2))
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func expenditureInfoView(expenseItem: ExpenseItem) -> some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                HStack {
                    Text("지출형태")
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body1))
                    Spacer()
                    if let method = viewStore.expenseDetailItem?.method {
                        Text(method == "CASH" ? "현금" : "카드")
                            .foregroundColor(.ybColor(.gray5))
                            .font(.ybfont(.body1))
                    }
                }
                if viewStore.expenseDetailItem?.category != .income {
                    HStack {
                        Text("카테고리")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body1))
                        Spacer()
                        Text(viewStore.expenseDetailItem?.category.text ?? viewStore.expenseItem.category.text)
                            .foregroundColor(.ybColor(.gray5))
                            .font(.ybfont(.body1))
                    }
                }
                HStack {
                    Text(expenseItem.category != .income ? "지출내용" : "예산내용")
                        .foregroundColor(.ybColor(.gray6))
                        .font(.ybfont(.body1))
                    Spacer()
                    Text(viewStore.expenseDetailItem?.name ?? expenseItem.name)
                        .foregroundColor(.ybColor(.gray5))
                        .font(.ybfont(.body1))
                }
                if let payerName =  viewStore.expenseDetailItem?.payerName,
                   viewStore.expenseDetailItem?.category != .income
                {
                    HStack {
                        Text("결제자")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body1))
                        Spacer()
                        Text(payerName)
                            .foregroundColor(.ybColor(.gray5))
                            .font(.ybfont(.body1))
                    }
                }
                if let payers = viewStore.expenseDetailItem?.payerList,
                   let firstPayer = payers.first {
                    let payerListString = payers.count > 1 ? "\(firstPayer.tripUserName ?? "") 외 \(payers.count - 1)명" : firstPayer.tripUserName ?? ""
                    HStack {
                        Text("돈 낸 사람")
                            .foregroundColor(.ybColor(.gray6))
                            .font(.ybfont(.body1))
                        Spacer()
                        Text(payerListString)
                            .foregroundColor(.ybColor(.gray5))
                            .font(.ybfont(.body1))
                    }
                }
            }
        }
    }

    var editButtonView: some View {
        Button {
            store.send(.tappedEditButton)
        } label: {
            Text("지출 내역 수정하기")
                .foregroundColor(.ybColor(.gray5))
                .font(.ybfont(.title1))
                .frame(height: 54)
                .frame(maxWidth: .infinity)
        }
        .background(YBColor.gray3.swiftUIColor)
        .cornerRadius(10)
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
}
