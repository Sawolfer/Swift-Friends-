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

    // MARK: - User Account Logic
    func createAccount(_ person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let userRef = firestore.collection(usersCollection).document(person.id.uuidString)
        do {
            try userRef.setData(from: person)
            completion(.success(()))
        } catch {
            completion(.failure(.download))
        }
    }

    func updateAccount(_ person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let userRef = firestore.collection(usersCollection).document(person.id.uuidString)
        do {
            try userRef.setData(from: person, merge: true)
            completion(.success(()))
        } catch {
            completion(.failure(.download))
        }
    }

    func deleteAccount(with id: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let userRef = firestore.collection(usersCollection).document(id.uuidString)
        userRef.delete { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 420, description: error.localizedDescription)))
                return
            }
            completion(.success(()))
        }
    }

    func uploadIcon(for person: Person, image: UIImage, completion: @escaping (Result<URL, NetworkError>) -> Void) {
        guard let imageData = image.pngData() else {
            completion(.failure(.custom(errorCode: 412, description: "No image data")))
            return
        }

        let userStorage = storage.reference().child("users/\(person.id.uuidString)/icon.jpg")

        userStorage.delete { error in
            userStorage.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(.custom(errorCode: 412, description: error.localizedDescription)))
                    return
                }
                userStorage.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(.download))
                        return
                    }
                    guard let url = url else {
                        completion(.failure(.custom(errorCode: 412, description: "No download URL")))
                        return
                    }
                    let userRef = self.firestore.collection("users").document(person.id.uuidString)
                    userRef.updateData([
                        "imageURL": url.absoluteString
                    ]) { error in
                        if let error = error {
                            completion(.failure(.custom(errorCode: 413, description: "Failed to update user profile: \(error.localizedDescription)")))
                            return
                        }
                        completion(.success(url))
                    }
                }
            }
        }
    }

    func findUser(by prefix: String, completion: @escaping (Result<[Person], NetworkError>) -> Void) {
        let start = prefix
        let end = prefix + "\u{f8ff}"

        firestore.collection(usersCollection)
            .whereField("name", isGreaterThanOrEqualTo: start)
            .whereField("name", isLessThan: end)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.custom(errorCode: 435, description: error.localizedDescription)))
                    return
                }
                let users = snapshot?.documents.compactMap { document -> Person? in
                    try? document.data(as: Person.self)
                } ?? []
                completion(.success(users))
            }
    }

}
