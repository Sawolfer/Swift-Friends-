//
//  SelectFriendsViewExpence.swift
//  Friends
//
//  Created by Алёна Максимова on 02.04.2025.
//

import SwiftUI

struct SelectFriendsViewExpence: View {
    @Environment(\.dismiss) var dismiss
    let friends: [Person]
    @State private var internalSelection: Set<Person.ID> = []
    @Binding var selectedFriends: [Person]

    var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Text("Add Friends")
                        .fontWeight(.medium)
                    Spacer()
                }

                Button("Done") {
                    selectedFriends = friends.filter({ internalSelection.contains($0.id) })
                    dismiss()
                }
                .fontWeight(.bold)
            }
            .padding([.horizontal, .top])

            List(friends, selection: $internalSelection) { person in
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
        .onAppear {
            internalSelection = Set(selectedFriends.map { $0.id })
        }
        .background(Color.background)
    }
}
