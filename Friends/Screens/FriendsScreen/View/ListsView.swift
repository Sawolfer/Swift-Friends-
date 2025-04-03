//
//  ListsView.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct ListsView: View {
    @ObservedObject var viewModel: FriendsViewModel

    var body: some View {
        GeometryReader { geometry in
            HStack {
                GroupsListView(viewModel: viewModel)
                    .frame(width: geometry.size.width)
                FriendsListView(friends: $viewModel.friends)
                    .frame(width: geometry.size.width)
            }
            .offset(x: viewModel.listOffset)
        }
    }
}
