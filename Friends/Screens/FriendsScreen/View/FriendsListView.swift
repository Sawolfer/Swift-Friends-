//
//  FriendsListView.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct FriendsListView: View {
    @Binding var friends: [Person]

    var body: some View {
        List {
            ForEach(friends, id: \.self) { friend in
                FriendCell(title: friend.name)
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}
