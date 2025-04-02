//
//  PeopleNetwork.swift
//  Friends
//
//  Created by Савва Пономарев on 01.04.2025.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation

class PeopleNetwork: PeopleNetworkProtocol {
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()
    private let usersCollection = "users"
//TODO: make authorization and login systems 

// MARK: - User Account Logic
    func createAccount(_ person: Person, completion: @escaping (Bool) -> Void) {
        let userRef = firestore.collection(usersCollection).document(
            person.id.uuidString)
        do {
            try userRef.setData(from: person)
            print("User successfully created")
            completion(true)
        } catch {
            print("Error while creating account: \(error.localizedDescription)")
            completion(false)
        }
    }
    func updateAccount(_ person: Person, completion: @escaping (Bool) -> Void) {
        let userRef = firestore.collection(usersCollection).document(
            person.id.uuidString)
        do {
            try userRef.setData(from: person, merge: true)
            print("User data successfully updated")
            completion(true)
        } catch {
            print("Error updating user data: \(error.localizedDescription)")
            completion(false)
        }
    }
    func deleteAccount(with id: UUID, completion: @escaping (Bool) -> Void) {
        let userRef = firestore.collection(usersCollection).document(
            id.uuidString)
        userRef.delete { error in
            if let error = error {
                print("Error deleting user: \(error.localizedDescription)")
                completion(false)
                return
            }
            print("User successfully deleted")
        }
    }
//   MARK: - Upload new icon
//    TODO: remove previous icon before adding new one
    func uploadIcon(for person: Person, image: UIImage) {
        guard let imageData = person.icon.pngData() else {
            print("No image data available")
            return
        }

        let userStorage = storage.reference().child("users/\(person.id.uuidString)/icon.jpg")
        userStorage.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            userStorage.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                } else {
                    print("Successfully uploaded icon image")
                    return
                }
            }
        }

    }
//  MARK: - Friends Management
//    TODO: add friends from both sides
    func addFriend(
        _ person: Person, to friendId: UUID,
        completion: @escaping (Bool) -> Void
    ) {
        firestore.collection(usersCollection).document(person.id.uuidString)
            .updateData([
                "friends": FieldValue.arrayUnion([friendId.uuidString])
            ]) { error in
                if let error = error {
                    print("Error adding friend: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                print("Friend successfully added")
                completion(true)
            }
    }
    func loadFriends(person: Person, completion: @escaping ([Person]) -> Void) {
        firestore.collection(usersCollection).document(person.id.uuidString)
            .getDocument { snapshot, error in
                if let error = error {
                    print(
                        "Error while loading friends: \(error.localizedDescription)"
                    )
                    completion([])
                    return
                }
                guard let data = snapshot?.data(),
                    let friendsIds = data["friends"] as? [UUID]
                else {
                    completion([])
                    return
                }
                let group = DispatchGroup()
                var friends: [Person] = []

                for friendId in friendsIds {
                    group.enter()
                    self.firestore.collection(self.usersCollection).document(
                        friendId.uuidString
                    ).getDocument { friendSnapshot, error in
                        if let error = error {
                            print(
                                "Error loading friend \(friendId): \(error.localizedDescription)"
                            )
                        } else if let friendData = friendSnapshot?.data() {
                            if let friend = try? Firestore.Decoder().decode(
                                Person.self, from: friendData)
                            {
                                friends.append(friend)
                            }
                        }
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    completion(friends)
                }
            }
    }
//    TODO: remove friends from both sides
    func removeFriend(
        person: Person, with friendId: UUID,
        completion: @escaping (Bool) -> Void
    ) {
        let userRef = firestore.collection(usersCollection).document(
            person.id.uuidString)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print(
                    "Error while removing friend: \(error.localizedDescription)"
                )
                completion(false)
                return
            }
            guard let data = snapshot?.data(),
                var friends = data["friends"] as? [String]
            else {
                completion(false)
                return
            }
            friends.removeAll { $0 == friendId.uuidString }

            userRef.updateData(["friends": friends]) { error in
                if let error = error {
                    print("Error writing data: \(error.localizedDescription)")
                    completion(!false)
                    return
                } else {
                    completion(true)
                    return
                }
            }
        }
    }
    // MARK: - Find Users
    func findUser(by prefix: String, completion: @escaping ([Person]) -> Void) {
        let start = prefix
        let end = prefix + "\u{f8ff}"

        firestore.collection(usersCollection)
            .whereField("name", isGreaterThanOrEqualTo: start)
            .whereField("name", isLessThan: end)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error finding users: \(error.localizedDescription)")
                    completion([])
                    return
                }
                let users =
                    snapshot?.documents.compactMap { document -> Person? in
                        try? document.data(as: Person.self)
                    } ?? []
                completion(users)
            }
    }
}
