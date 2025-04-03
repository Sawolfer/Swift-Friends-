//
//  AddFriendViewModel.swift
//  Friends
//
//  Created by тимур on 03.04.2025.
//

import Foundation

final class AddFriendViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var users = [Person]()
    @Published var errorMessage = ""
    @Published var isLoading: Bool = false

    private let peopleProvider = PeopleNetwork()
    private let friendProvider = FriendsNetwork()

    func searchUsers() {
        peopleProvider.findUser(by: searchText) { [weak self] result in
            switch result {
            case .success(let persons):
                self?.users = persons
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }

    func isFriend(friendId: UUID, completion: @escaping (Bool) -> Void) {
        let id = UUID(uuidString: "89D5A287-3DF5-4F41-90B7-CFD8BD61D4C8")!
        friendProvider.loadFriends(id: id) { [weak self] result in
            switch result {
            case .success(let friends):
                if friends.contains(where: { $0.id == friendId }) {
                    completion(true)
                }

                completion(false)
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
                completion(false)
            }
        }
    }

    func addFriend(friendId: UUID) {
        let id = UUID(uuidString: "89D5A287-3DF5-4F41-90B7-CFD8BD61D4C8")!
        friendProvider.sendFriendRequest(id: id, to: friendId) { _ in }
    }
}
