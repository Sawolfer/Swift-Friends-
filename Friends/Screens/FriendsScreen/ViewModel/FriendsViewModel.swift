//
//  FriendsViewModel.swift
//  Friends
//
//  Created by Алексей on 03.04.2025.
//

import SwiftUI

final class FriendsViewModel: NSObject, ObservableObject {
    // MARK: - Constants

    private enum Constants {
        static let animationDuration: Double = 0.2
        static let previewFriendsLimit: Int = 4
        static let additionalOffset: CGFloat = 10
    }

    // MARK: - Properties

    @Published var groups: [GroupModels.Group] = [GroupModels.Group(
        id: UUID(),
        title: "Yandex Go",
        friends: [
            Person(id: UUID(), name: "Aboba", username: "Am", password: "1234postgres", debts: []),
            Person(id: UUID(), name: "Floppa", username: "a", password: "1234postgres", debts: []),
            Person(id: UUID(), name: "Gg", username: "x", password: "1234postgres", debts: []),
            Person(id: UUID(), name: "Aboba", username: "s", password: "1234postgres", debts: []),
            Person(id: UUID(), name: "Aboba", username: "swqf", password: "1234postgres", debts: [])
        ]

        ),
        GroupModels.Group(
            id: UUID(),
            title: "Sirius",
            friends: [
                Person(id: UUID(), name: "Aboba", username: "Am", password: "1234postgres", debts: [])
            ]
        )
    ]
    @Published var friends: [Person] = [
        Person(id: UUID(), name: "Aboba", username: "Am", password: "1234postgres", debts: []),
        Person(id: UUID(), name: "Floppa", username: "a", password: "1234postgres", debts: []),
        Person(id: UUID(), name: "Gg", username: "x", password: "1234postgres", debts: []),
        Person(id: UUID(), name: "Aboba", username: "s", password: "1234postgres", debts: []),
        Person(id: UUID(), name: "Aboba", username: "swqf", password: "1234postgres", debts: [])
    ]

    @Published var selectedSegment: Int = 0
    @Published var listOffset: CGFloat = 0

    // MARK: - Functions

    func segmentedChanged() {
        withAnimation(.easeInOut(duration: Constants.animationDuration)) {
            listOffset = selectedSegment == 0 ? 0 : -UIScreen.main.bounds.width - Constants.additionalOffset
        }
    }

    func getFriendsAndPreviewDifference(friendsCount: Int) -> Int {
        return friendsCount - Constants.previewFriendsLimit
    }
}
