//
//  TripUsersView.swift
//  Home
//
//  Created by Hoyoung Lee on 2/14/24.
//  Copyright © 2024 YeoBee.com. All rights reserved.
//

import SwiftUI
import Entity

final class TripUsersHostingController: UIHostingController<TripUsersView> {
}

struct TripUsersView: View {
    var tripUsers: [TripUserItem]

    init(tripUsers: [TripUserItem]) {
        self.tripUsers = tripUsers
    }

    var body: some View {
        ZStack {
            ForEach(0..<min(tripUsers.count, 4)) { index in
                    tripUserView(tripUserItem: tripUsers[index])
                        .offset(x: CGFloat(index) * 20)
                }
                if tripUsers.count >= 4 {
                    tripUserWithNumberView(tripUserItem: tripUsers[3], count: tripUsers.count - 3)
                        .offset(x: CGFloat(3) * 20)
                }
        }
    }

    func tripUserView(tripUserItem: TripUserItem) -> some View {
        ZStack {
            Color.white
                .clipShape(Circle())
                .frame(width: 28, height: 28)
            AsyncImage(url: URL(string: tripUserItem.profileImageUrl ?? ""), scale: 26)
                .clipShape(Circle())
                .frame(width: 26, height: 26)
        }
    }

    func tripUserWithNumberView(tripUserItem: TripUserItem, count: Int) -> some View {
        ZStack {
            Color.white
                .clipShape(Circle())
                .frame(width: 28, height: 28)
            AsyncImage(url: URL(string: tripUserItem.profileImageUrl ?? ""), scale: 26)
                .clipShape(Circle())
                .frame(width: 26, height: 26)
            Color.black.opacity(0.7)
                .clipShape(Circle())
                .frame(width: 26, height: 26)
            Text("+\(count)")
                .font(.ybfont(.body3))
                .foregroundColor(.ybColor(.white))
        }
    }
}

#Preview {
    TripUsersView(tripUsers: [
        .init(id: 1, userId: 1),
        .init(id: 2, userId: 2),
        .init(id: 3, userId: 3),
        .init(id: 4, userId: 4),
        .init(id: 5, userId: 5)
    ])
}
