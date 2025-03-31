//
//  Person.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit

struct Person {
    let id = UUID()
    var name: String
    var imageURL: URL?
    var isSelectedFirstTime = true

    var icon: UIImage {
        if let imageURL = imageURL,
           let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            return image
        }
        return UIImage(systemName: "person.circle")!
    }

    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Person: Identifiable, Equatable, Hashable {}

class PersonContainer {
    let user: Person

    static let shared: PersonContainer = PersonContainer()

    private var debtFrom: [Debt]
    private var debtTo: [Debt]

//    TODO: убрать временную реализацию 
    private init() {
        self.user = Person(name: "Jhon Swag")
        debtTo = [Debt(personTo: Person(name: "Оксимирон"), personFrom: self.user, debt: 5)] /*Tempruary realization*/
        debtFrom = [Debt(personTo: self.user, personFrom: Person(name: "kizaru"), debt: 123456)] /*Tempruary realization*/
    }

    public func getDebts(dest: DebtType) -> [Debt]{
        switch dest {
            case .from :
                return debtFrom
            case .to :
                return debtTo
            default:
                return []
        }
    }

    public func addDebt(_ debt: Double, dest: DebtType, person: Person?) {
        guard let person = person else { return }
        
        switch dest {
            case .from:
                debtFrom.append(Debt(personTo: person, personFrom: PersonContainer.shared.user, debt: debt))
            case .to:
                debtTo.append(Debt(personTo: PersonContainer.shared.user, personFrom: person, debt: debt))

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
                    if let index = debtFrom.firstIndex(where: { $0.personFrom.id == person.id }) {
                        debtFrom[index].debt += debt
                    } else if let index = debtTo.firstIndex(where: { $0.personTo.id == person.id }) {
                        if debtTo[index].debt > debt {
                            debtTo[index].debt -= debt
                        } else {
                            let remainingDebt = debt - debtTo[index].debt
                            debtTo.remove(at: index)
                            if remainingDebt > 0 {
                                debtFrom.append(Debt(personTo: person, personFrom: user, debt: remainingDebt))
                            }
                        }
                    } else {
                        debtFrom.append(Debt(personTo: person, personFrom: user, debt: debt))
                    }

                case .to:
                    if let index = debtTo.firstIndex(where: { $0.personTo.id == person.id }) {
                        debtTo[index].debt += debt
                    } else if let index = debtFrom.firstIndex(where: { $0.personFrom.id == person.id }) {
                        if debtFrom[index].debt > debt {
                            debtFrom[index].debt -= debt
                        } else {
                            let remainingDebt = debt - debtFrom[index].debt
                            debtFrom.remove(at: index)
                            if remainingDebt > 0 {
                                debtTo.append(Debt(personTo: user, personFrom: person, debt: remainingDebt))
                            }
                        }
                    } else {
                        debtTo.append(Debt(personTo: user, personFrom: person, debt: debt))
                    }
            }
    }

    public func getDebt(of person: Person) -> Double {
        if isDebitor(person) {
            return debtTo.first(where: { $0.personTo.id == person.id })?.debt ?? 0
        }
        return debtFrom.first(where: { $0.personFrom.id == person.id })?.debt ?? 0
    }

    public func getDebtsSum(dest: DebtType) -> Double {
        switch dest{
            case .from :
                return debtFrom.reduce(0) { $0 + $1.debt }
            case .to :
                return debtTo.reduce(0) { $0 + $1.debt }
            default:
                return 0

        }
    }
}
