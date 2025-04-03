//
//  AuthNetwork.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import FirebaseFirestore
import FirebaseStorage
import Foundation
import CryptoKit


class AuthNetwork {
    private let firestore = Firestore.firestore()
    private let storage = Storage.storage()
    private let usersCollection = "users"
    private let authCollection = "auth"

// MARK: - Account Creation
    func createAccount(name: String, username: String, password: String, completion: @escaping (Result<Person, NetworkError>) -> Void) {
        firestore.collection(authCollection)
            .whereField("name", isEqualTo: name)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.custom(errorCode: 500, description: error.localizedDescription)))
                    return
                }
// MARK: - check for unique username
                if let snapshot = snapshot, !snapshot.documents.isEmpty {
                    completion(.failure(.custom(errorCode: 409, description: "Username already exists")))
                    return
                }
// MARK: - create new person
                let personId = UUID()
                let person = Person(
                    id: personId,
                    name: name,
                    username: username,
                    password: password,
                    imageURL: nil,
                    friends: [],
                    debts: []
                )
// MARK: - create auth document
                let authData: [String: Any] = [
                    "userId": personId.uuidString,
                    "name": name,
                    "username": username,
                    "password": self.hashPassword(password),
                ]

                let batch = self.firestore.batch()
                let userRef = self.firestore.collection(self.usersCollection).document(personId.uuidString)
                let authRef = self.firestore.collection(self.authCollection).document(personId.uuidString)

                do {
                    try batch.setData(from: person, forDocument: userRef)
                    batch.setData(authData, forDocument: authRef)

                    batch.commit { error in
                        if let error = error {
                            completion(.failure(.custom(errorCode: 500, description: error.localizedDescription)))
                            return
                        }
                        self.cacheUserData(person: person)
                        completion(.success(person))
                    }
                } catch {
                    completion(.failure(.custom(errorCode: 500, description: "Failed to create user")))
                }
            }
    }

// MARK: - Login
    func login(name: String, password: String, completion: @escaping (Result<Person, NetworkError>) -> Void) {
        firestore.collection(authCollection)
            .whereField("name", isEqualTo: name)
            .whereField("password", isEqualTo: self.hashPassword(password))
            .getDocuments { snapshot, error in

                if let error = error {
                    completion(.failure(.custom(errorCode: 500, description: error.localizedDescription)))
                    return
                }

                guard let document = snapshot?.documents.first,
                      let userId = document.data()["userId"] as? String else {
                    completion(.failure(.custom(errorCode: 401, description: "Invalid credentials")))
                    return
                }
                self.firestore.collection(self.usersCollection).document(userId).getDocument { snapshot, error in
                    if let error = error {
                        completion(.failure(.custom(errorCode: 500, description: error.localizedDescription)))
                        return
                    }
                    guard let snapshot = snapshot,
                          let person = try? snapshot.data(as: Person.self) else {
                        completion(.failure(.custom(errorCode: 404, description: "User not found")))
                        return
                    }
                    self.cacheUserData(person: person)

                    completion(.success(person))
                }
            }
    }

// MARK: - Cache Account (placeholder)
    private func cacheUserData(person: Person) {
        let cache = CahcheUserInfo()
        let userInfo: [String: Any] = [
            "username" : person.username,
            "password" : person.password
        ]
        cache.saveUserInfo(userInfo: userInfo)
    }

// MARK: - Name Unique check
    func checkNameAvailability(name: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        firestore.collection(authCollection)
            .whereField("name", isEqualTo: name)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.custom(errorCode: 500, description: error.localizedDescription)))
                    return
                }

                let isAvailable = snapshot?.documents.isEmpty ?? true
                completion(.success(isAvailable))
            }
    }
// MARK: - Hash Password
    func hashPassword(_ password: String) -> String {
        let data = Data(password.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}
