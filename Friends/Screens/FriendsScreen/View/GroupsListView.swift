//
//  GroupsListView.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

struct GroupsListView: View {
    @ObservedObject var viewModel: FriendsViewModel

    var body: some View {
        List {
            ForEach(viewModel.groups.indices, id: \.self) { index in
                GroupCell(viewModel: viewModel, group: $viewModel.groups[index])
            }
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}
