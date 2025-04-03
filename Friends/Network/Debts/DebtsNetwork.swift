//
//  DebtsNetwork.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation
import FirebaseFirestore

class DebtsNetwork: DebtsNetworkProtocol {
    private let firestore = Firestore.firestore()
    private let debtsCollection = "debts"
    private let usersCollection = "users"

    func loadDebts(for person: Person, completion: @escaping (Result<[Debt], NetworkError>) -> Void) {
        firestore.collection(debtsCollection)
            .whereField("participants", arrayContains: person.id.uuidString)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.custom(errorCode: 421, description: error.localizedDescription)))
                    return
                }
                let debts = snapshot?.documents.compactMap { document -> Debt? in
                    try? document.data(as: Debt.self)
                } ?? []
                completion(.success(debts))
            }
    }

    func addDebt(_ person: Person, to debt: Debt, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let batch = firestore.batch()

        let debtRef = firestore.collection(debtsCollection).document(debt.id.uuidString)
        do {
            try batch.setData(from: debt, forDocument: debtRef)
        } catch {
            completion(.failure(.download))
            return
        }

        let fromUserRef = firestore.collection(usersCollection).document(debt.personFrom.id.uuidString)
        let toUserRef = firestore.collection(usersCollection).document(debt.personTo.id.uuidString)

        batch.updateData([
            "debts": FieldValue.arrayUnion([debt.id.uuidString])
        ], forDocument: fromUserRef)

        batch.updateData([
            "debts": FieldValue.arrayUnion([debt.id.uuidString])
        ], forDocument: toUserRef)

        batch.commit { error in
            if let error = error {
                completion(.failure(.custom(errorCode: 422, description: error.localizedDescription)))
                return
            }
            completion(.success(()))
        }
    }

    func removeDebt(_ person: Person, from debtId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let batch = firestore.batch()
        let debtRef = firestore.collection(debtsCollection).document(debtId.uuidString)

        debtRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.custom(errorCode: 423, description: error.localizedDescription)))
                return
            }

            guard let debt = try? snapshot?.data(as: Debt.self) else {
                completion(.failure(.custom(errorCode: 424, description: "Debt not found")))
                return
            }

            batch.deleteDocument(debtRef)

            let fromUserRef = self.firestore.collection(self.usersCollection).document(debt.personFrom.id.uuidString)
            let toUserRef = self.firestore.collection(self.usersCollection).document(debt.personTo.id.uuidString)

            batch.updateData([
                "debts": FieldValue.arrayRemove([debtId.uuidString])
            ], forDocument: fromUserRef)

            batch.updateData([
                "debts": FieldValue.arrayRemove([debtId.uuidString])
            ], forDocument: toUserRef)

            batch.commit { error in
                if let error = error {
                    completion(.failure(.custom(errorCode: 425, description: error.localizedDescription)))
                    return
                }
                completion(.success(()))
            }
        }
    }
}
