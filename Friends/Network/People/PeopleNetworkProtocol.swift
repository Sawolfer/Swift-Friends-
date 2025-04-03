//
//  PeopleNetworkProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 01.04.2025.
//

import Foundation
import UIKit

protocol PeopleNetworkProtocol {
    // MARK: - User Account Logic

    func createAccount(_ person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func updateAccount(_ person: Person, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func deleteAccount(with id: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func uploadIcon(for person: Person, image: UIImage, completion: @escaping (Result<URL, NetworkError>) -> Void)
    // MARK: - Find Users

    func findUser(by prefix: String, completion: @escaping (Result<[Person], NetworkError>) -> Void)
}
