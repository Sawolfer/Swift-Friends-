//
//  GroupsNetwork.swift
//  Friends
//
//  Created by Савва Пономарев on 04.04.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage


class GroupsNetwork: GroupsNetworkProtocol {
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()
    private let usersCollection = "users"
    private let groupsCollection = "groups"

    // MARK: - Group Logic
    func createGroup(name: String, members: [Person], completion: @escaping (Result<String, NetworkError>) -> Void) {
        let groupID = UUID().uuidString
        let groupData: [String: Any] = [
            "id": groupID,
            "name": name,
            "members": members.map { $0.id.uuidString }
        ]

        firestore.collection(groupsCollection).document(groupID).setData(groupData) { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 500, description: error.localizedDescription)))
            } else {
                completion(.success(groupID))
            }
        }
    }

    func addPersonToGroup(groupID: String, person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let groupRef = firestore.collection(groupsCollection).document(groupID)

        groupRef.updateData([
            "members": FieldValue.arrayUnion([person.id.uuidString])
        ]) { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 501, description: error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }

    func removePersonFromGroup(groupID: String, person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let groupRef = firestore.collection(groupsCollection).document(groupID)

        groupRef.updateData([
            "members": FieldValue.arrayRemove([person.id.uuidString])
        ]) { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 502, description: error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }

    func deleteGroup(groupID: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        firestore.collection(groupsCollection).document(groupID).delete { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 503, description: error.localizedDescription)))
            } else {
                completion(.success(()))
            }
        }
    }
}
