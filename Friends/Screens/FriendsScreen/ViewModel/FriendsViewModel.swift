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
            Person(
                name: "Aboba"
            ),
            Person(
                name: "Floppa"
            )]),
        GroupModels.Group(
            id: UUID(),
            title: "Sirius",
            friends: [
                Person(
                    name: "Aboba"
                ),
                Person(
                    name: "Floppa"
                ),
                Person(
                    name: "Floppa"
                ),
                Person(
                    name: "Floppa"
                ),
                Person(
                    name: "Floppa"
                ),
                Person(
                    name: "Floppa"
                )
        ])
    ]
    @Published var friends: [Person] = [
        Person(name: "Aboba"),
        Person(name: "Amogus"),
        Person(name: "Floppa")
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
