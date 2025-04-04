//
//  AddFriendView.swift
//  Friends
//
//  Created by тимур on 03.04.2025.
//

import SwiftUI

struct AddFriendView: View {
    @StateObject var viewModel = AddFriendViewModel()

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.users) { person in
                    HStack {
                        Image(uiImage: person.icon)
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                            .clipShape(Circle())
                        Text(person.name)
                        Spacer()
                        Button(action: {
                            // TODO: Add Friend Action
                            viewModel.addFriend(friendId: person.id)
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
            .navigationTitle("Добавить друга")
            .searchable(text: $viewModel.searchText, prompt: "Поиск по логину")
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onChange(of: viewModel.searchText) { newValue in
                if newValue.count > 2 {
                    viewModel.searchUsers()
                } else {
                    viewModel.users = []
                }
            }
        }
    }
}

#Preview {
    AddFriendView()
}
