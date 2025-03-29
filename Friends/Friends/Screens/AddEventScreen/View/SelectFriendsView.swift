//
//  SelectFriendsView.swift
//  Friends
//
//  Created by тимур on 28.03.2025.
//

import SwiftUI

struct SelectFriendsView: View {
    @StateObject var viewModel: SelectFriendsViewModel

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Button("Cancel") {}
                Spacer()
                Text("Add Friends")
                    .fontWeight(.medium)
                Spacer()
                Button("Add") {}
                    .fontWeight(.bold)
                    .disabled(viewModel.selectedFriends.isEmpty)
            }
            .padding([.horizontal, .top])

            List(viewModel.friends, selection: $viewModel.selectedFriends) { person in
                HStack {
                    Image(person.photo ?? "")
                        .resizable()
                        .frame(width: 40.0, height: 40.0)
                        .clipShape(Circle())
                    Text(person.name)
                }
            }
            .environment(\.editMode, .constant(.active))
        }
        .background(Color.background)
    }
}

#Preview {
    SelectFriendsView(viewModel: SelectFriendsViewModel())
}
