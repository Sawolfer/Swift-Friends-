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

    private let peopleProvider = PersonNetwork()
    private let friendProvider = FriendsNetwork()
    private let cache = AppCache.shared

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
        guard let id = cache.user?.id else {
            print("no user for isFriend")
            return
        }
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
        guard let id = cache.user?.id else {
            print("no user for addFriend")
            return
        }
        friendProvider.sendFriendRequest(id: id, to: friendId) { _ in }
    }
}
