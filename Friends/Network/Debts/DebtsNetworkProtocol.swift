//
//  DebtsNetworkProtocol.swift
//  Friends
//
//  Created by Савва Пономарев on 03.04.2025.
//

import Foundation

protocol DebtsNetworkProtocol {
    func loadDebts(for person: Person, completion: @escaping (Result<[Debt], NetworkError>) -> Void)
    func addDebt(_ person: Person, to debt: Debt, completion: @escaping (Result<Void, NetworkError>) -> Void)
    func removeDebt(_ person: Person, from debtId: UUID, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
