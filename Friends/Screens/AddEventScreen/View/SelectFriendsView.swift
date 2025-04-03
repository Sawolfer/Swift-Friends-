//
//  SelectFriendsView.swift
//  Friends
//
//  Created by тимур on 28.03.2025.
//

import SwiftUI

struct SelectFriendsView: View {
    @ObservedObject var viewModel: AddEventViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Text("Добавить друзей")
                        .fontWeight(.medium)
                    Spacer()
                }

                Button("Готово") {
                    dismiss()
                }
                .fontWeight(.bold)
            }
            .padding([.horizontal, .top])

            List(viewModel.friends, selection: $viewModel.selectedFriends) { person in
                HStack {
                    Image(uiImage: person.icon)
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
