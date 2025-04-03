//
//  FriendsNetworkProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation

protocol FriendsNetworkProtocol {
    func sendFriendRequest(_ person: Person, to friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func loadFriends(person: Person, completion: @escaping (Result<[Person], NetworkError>) -> Void)
    func removeFriend(person: Person, with friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
