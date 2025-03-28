//
//  Person.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit

struct Person{
    var icon: UIImage {
        return UIImage(named: "custom") ?? UIImage(systemName: "person.circle")!
    }
    var name: String
    var id = UUID()
}

extension Person : Identifiable, Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
}

// TODO: решить что мы будем использовать в качествве структуры данных

class PersonContainer {
    static var shared: PersonContainer = PersonContainer()
    
    private var debtFrom: [Debt]
    private var debtTo: [Debt]
    
    private init() {
        debtFrom = []
        debtTo = []
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
