//
//  AgreeSheetView.swift
//  Sign
//
//  Created Hoyoung Lee on 2/19/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.

import SwiftUI
import ComposableArchitecture
import DesignSystem

final class AgreeSheetHostingController: UIHostingController<AgreeSheetView> {
}

struct AgreeSheetView: View {
    typealias State = AgreeSheetReducer.State
    typealias Action = AgreeSheetReducer.Action

    let store: StoreOf<AgreeSheetReducer>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 20) {
                Text("약관에 동의해주세요")
                    .foregroundColor(.ybColor(.black))
                    .font(.ybfont(.title1))
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 10) {
                        Button {
                            viewStore.send(.tappedTotal(!viewStore.totalChecking))
                        } label: {
                            if viewStore.totalChecking {
                                DesignSystemAsset.Icons.checkFill.swiftUIImage
                                    .frame(width: 28, height: 28)
                            } else {
                                DesignSystemAsset.Icons.uncheck.swiftUIImage
                                    .frame(width: 28, height: 28)
                            }
                            Text("약관 전체 동의")
                                .foregroundColor(.ybColor(.gray6))
                                .font(.ybfont(.body1))
                        }
                    }
                    YBDividerView()
                    HStack(spacing: 10) {
                        Button {
                            viewStore.send(.tappedPrivate(!viewStore.privateData))
                        } label: {
                            if viewStore.privateData {
                                DesignSystemAsset.Icons.checkFill.swiftUIImage
                                    .frame(width: 28, height: 28)
                            } else {
                                DesignSystemAsset.Icons.uncheck.swiftUIImage
                                    .frame(width: 28, height: 28)
                            }
                            Text("개인정보 처리방침 동의 (필수)")
                                .foregroundColor(.ybColor(.gray6))
                                .font(.ybfont(.body2))
                        }
                        Spacer()
                        Button {
                            let url = URL(string: "https://m.cafe.naver.com/ca-fe/web/cafes/yeobee/articles/2?useCafeId=false&tc")
                            if let url {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            DesignSystemAsset.Icons.next.swiftUIImage
                                .frame(width: 28, height: 28)
                        }
                    }
                    HStack(spacing: 10) {
                        Button {
                            viewStore.send(.tappedService(!viewStore.serviceData))
                        } label: {
                            if viewStore.serviceData {
                                DesignSystemAsset.Icons.checkFill.swiftUIImage
                                    .frame(width: 28, height: 28)
                            } else {
                                DesignSystemAsset.Icons.uncheck.swiftUIImage
                                    .frame(width: 28, height: 28)
                            }
                            Text("서비스 이용 약관 동의 (필수)")
                                .foregroundColor(.ybColor(.gray6))
                                .font(.ybfont(.body2))
                        }
                        Spacer()
                        Button {
                            let url = URL(string: "https://m.cafe.naver.com/ca-fe/web/cafes/31153021/articles/6?fromList=true&menuId=10&tc=cafe_article_list")
                            if let url {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            DesignSystemAsset.Icons.next.swiftUIImage
                                .frame(width: 28, height: 28)
                        }
                    }
                }
                Button {
                    viewStore.send(.tappedConfirmButton)
                } label: {
                    Text("등록하기")
                        .foregroundColor(viewStore.isEnabledCompletedButton ? .ybColor(.white) : .ybColor(.gray5))
                        .font(.ybfont(.title1))
                        .frame(height: 54)
                        .frame(maxWidth: .infinity)
                }
                .disabled(viewStore.isEnabledCompletedButton == false)
                .background(viewStore.isEnabledCompletedButton ? YBColor.black.swiftUIColor : YBColor.gray3.swiftUIColor)
                .cornerRadius(10)
                .padding(.top, 16)
                .padding(.bottom, 4)
            }
        }
    }
}
