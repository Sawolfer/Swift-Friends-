//
//  Person.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.

import UIKit

struct Person: Codable {
    var id: UUID
    var name: String
    var username: String
    var password: String
    var imageURL: URL?
    var friends: [UUID] = []
    var debts: [Debt]

    var icon: UIImage {
        if let imageURL = imageURL,
            let imageData = try? Data(contentsOf: imageURL),
            let image = UIImage(data: imageData) {
            return image
        }

        return UIImage(systemName: "person.circle")!
    }
}

// MARK: - Equatable

extension Person: Identifiable, Equatable, Hashable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Person: Identifiable, Hashable{}

//MARK: - Debt Functions
extension Person {
    func getDebts() -> [Debt] {
        debts.filter { $0.personFrom == self }
    }
    func getDebitors() -> [Debt] {
        debts.filter { $0.personTo == self }
    }
    mutating func addDebt(_ debt: Debt) {
        debts.append(debt)
    }
    mutating func removeDebt(_ debt: Debt) {
        debts.removeAll { $0.id == debt.id }
    }
    mutating func updateDebt(_ debt: Debt) {
        debts.removeAll { $0.id == debt.id }
        debts.append(debt)
    }
}

// TODO: remove container

class PersonContainer {
    let user: Person

    static let shared: PersonContainer = PersonContainer()

    private var debtFrom: [Debt]
    private var debtTo: [Debt]

    //    TODO: убрать временную реализацию
    private init() {
        self.user = Person(id: UUID(), name: "TestUser", username: "testUser", password: "12435-adsfa-34141234", debts: [])
        self.debtFrom = []
        self.debtTo = []
    }

    public func getDebts(dest: DebtType) -> [Debt] {
        switch dest {
        case .from:
            return debtFrom
        case .to:
            return debtTo
        }
    }

    public func addDebt(_ debt: Double, dest: DebtType, person: Person?) {
        guard let person = person else { return }

        switch dest {
        case .from:
            debtFrom.append(
                Debt(
                    personTo: person, personFrom: PersonContainer.shared.user,
                    debt: debt))
        case .to:
            debtTo.append(
                Debt(
                    personTo: PersonContainer.shared.user, personFrom: person,
                    debt: debt))

        }
    }

    public func isDebitor(_ person: Person) -> Bool {
        if debtTo.contains(where: { $0.personTo.id == person.id }) {
            return true
        }
        return false
    }

    public func getPeople() -> [Person] {
        var people: [Person] = []

        debtTo.forEach { person in
            people.append(person.personTo)
        }

        debtFrom.forEach { person in
            people.append(person.personFrom)
        }
        return people
    }

    public func editDebt(_ debt: Double, dest: DebtType, person: Person?) {
        guard let person = person else { return }

        guard debt > 0 else { return }

        switch dest {
        case .from:
            if let index = debtFrom.firstIndex(where: {
                $0.personFrom.id == person.id
            }) {
                debtFrom[index].debt += debt
            } else if let index = debtTo.firstIndex(where: {
                $0.personTo.id == person.id
            }) {
                if debtTo[index].debt > debt {
                    debtTo[index].debt -= debt
                } else {
                    let remainingDebt = debt - debtTo[index].debt
                    debtTo.remove(at: index)
                    if remainingDebt > 0 {
                        debtFrom.append(
                            Debt(
                                personTo: person, personFrom: user,
                                debt: remainingDebt))
                    }
                }
            } else {
                debtFrom.append(
                    Debt(personTo: person, personFrom: user, debt: debt))
            }

        case .to:
            if let index = debtTo.firstIndex(where: {
                $0.personTo.id == person.id
            }) {
                debtTo[index].debt += debt
            } else if let index = debtFrom.firstIndex(where: {
                $0.personFrom.id == person.id
            }) {
                if debtFrom[index].debt > debt {
                    debtFrom[index].debt -= debt
                } else {
                    let remainingDebt = debt - debtFrom[index].debt
                    debtFrom.remove(at: index)
                    if remainingDebt > 0 {
                        debtTo.append(
                            Debt(
                                personTo: user, personFrom: person,
                                debt: remainingDebt))
                    }
                }
            } else {
                debtTo.append(
                    Debt(personTo: user, personFrom: person, debt: debt))
            }
        }
    }

    public func getDebt(of person: Person) -> Double {
        if isDebitor(person) {
            return debtTo.first(where: { $0.personTo.id == person.id })?.debt
                ?? 0
        }
        return debtFrom.first(where: { $0.personFrom.id == person.id })?.debt
            ?? 0
    }

    public func getDebtsSum(dest: DebtType) -> Double {
        switch dest {
        case .from:
            return debtFrom.reduce(0) { $0 + $1.debt }
        case .to:
            return debtTo.reduce(0) { $0 + $1.debt }
        }
    }
}
