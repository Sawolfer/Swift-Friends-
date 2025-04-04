//
//  FriendsNetworkProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation

protocol FriendsNetworkProtocol {
    func sendFriendRequest(id: UUID, to friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func loadFriends(id: UUID, completion: @escaping (Result<[Person], NetworkError>) -> Void)
    func removeFriend(id: UUID, with friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
