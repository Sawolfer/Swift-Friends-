//
//  GroupsNetworkProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 04.04.2025.
//

import Foundation

protocol GroupsNetworkProtocol {
    func createGroup(name: String, members: [Person], completion: @escaping (Result<String, NetworkError>) -> Void)
    func addPersonToGroup(groupID: String, person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func removePersonFromGroup(groupID: String, person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func deleteGroup(groupID: String, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
