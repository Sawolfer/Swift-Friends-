//
//  PeopleNetworkProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 01.04.2025.
//

import Foundation


protocol PeopleNetworkProtocol {
    func createAccount(_ person: Person, completion: @escaping (Bool) -> Void)
    func updateAccount(_ person: Person, completion: @escaping (Bool) -> Void)
    func deleteAccount(with id: UUID, completion: @escaping (Bool) -> Void)
    func addFriend(_ person: Person, to friendId: UUID, completion: @escaping (Bool) -> Void)
    func loadFriends(person: Person, completion: @escaping ([Person]) -> Void)
    func removeFriend(person: Person, with friendId: UUID, completion: @escaping (Bool) -> Void)
    func findUser(by prefix: String, completion: @escaping ([Person]) -> Void)
}
