//
//  FriendsNetwork.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import FirebaseFirestore
import Foundation

class FriendsNetwork: FriendsNetworkProtocol {
    private let firestore = Firestore.firestore()
    private let usersCollection = "users"
    private let friendRequestsCollection = "friendRequests"

    func sendFriendRequest(_ person: Person, to friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let batch = firestore.batch()
        let requestId = UUID().uuidString

        let requestRef = firestore.collection(friendRequestsCollection).document(requestId)
        let requestData: [String: Any] = [
            "id": requestId,
            "fromUserId": person.id.uuidString,
            "toUserId": friendId.uuidString,
            "status": "pending",
            "createdAt": Timestamp(date: Date())
        ]
        batch.setData(requestData, forDocument: requestRef)

        let userRef = firestore.collection(usersCollection).document(person.id.uuidString)
        let friendRef = firestore.collection(usersCollection).document(friendId.uuidString)

        batch.updateData([
            "friends": FieldValue.arrayUnion([friendId.uuidString])
        ], forDocument: userRef)

        batch.updateData([
            "friends": FieldValue.arrayUnion([person.id.uuidString])
        ], forDocument: friendRef)

        batch.commit { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 427, description: error.localizedDescription)))
                return
            }
            completion(.success(()))
        }
    }

    func loadFriends(id: UUID, completion: @escaping (Result<[Person], NetworkError>) -> Void) {
        firestore.collection(usersCollection).document(id.uuidString)
            .getDocument { snapshot, error in
                if let error = error {
                    completion(.failure(.custom(errorCode: 433, description: error.localizedDescription)))
                    return
                }

                guard let data = snapshot?.data(),
                      let friendsIds = data["friends"] as? [String] else {
                    completion(.success([]))
                    return
                }

                let group = DispatchGroup()
                var friends: [Person] = []

                for friendId in friendsIds {
                    group.enter()
                    self.firestore.collection(self.usersCollection).document(friendId).getDocument { friendSnapshot, error in
                        if error != nil {
                            completion(.failure(.download))
                            group.leave()
                            return
                        }
                        if let friendData = friendSnapshot?.data(),
                           let friend = try? Firestore.Decoder().decode(Person.self, from: friendData) {
                            friends.append(friend)
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    completion(.success(friends))
                }
            }
    }

    func removeFriend(person: Person, with friendId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let batch = firestore.batch()

        let userRef = firestore.collection(usersCollection).document(person.id.uuidString)
        let friendRef = firestore.collection(usersCollection).document(friendId.uuidString)

        batch.updateData([
            "friends": FieldValue.arrayRemove([friendId.uuidString])
        ], forDocument: userRef)

        batch.updateData([
            "friends": FieldValue.arrayRemove([person.id.uuidString])
        ], forDocument: friendRef)

        batch.commit { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 434, description: error.localizedDescription)))
                return
            }
            completion(.success(()))
        }
    }
}
