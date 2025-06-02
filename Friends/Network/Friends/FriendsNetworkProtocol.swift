//
//  FriendsNetworkProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation

protocol FriendsNetworkProtocol {
    func sendFriendRequest(to friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func loadFriends(completion: @escaping (Result<[Person], NetworkError>) -> Void)
    func removeFriend(with friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
