//
//  Person.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit

struct Person : Identifiable, Hashable{
    var icon: UIImage {
        return UIImage(named: "custom") ?? UIImage(systemName: "person.circle")!
    }
    var name: String
    var debt: Double
    var id = UUID()
}

// TODO: решить что мы будем использовать в качествве структуры данных

class PersonContainer{
    static var shared: PersonContainer = PersonContainer()

    private var persons = Dictionary<Person, [Debt]>()
    private init(){}

//    public func getPersons() -> [Person]{
//
//    }

    public func addPerson(_ person: Person, title: String){
        print("Adding person \(person.name)")
        let debt = Debt(debt: person.debt, title: title)

        if persons.keys.contains(person){
            persons[person]?.append(debt)
        } else {
            persons[person] = []
            persons[person]?.append(debt)
        }
    }

    public func removePerson(_ person: Person){
        print("Removing person \(person.name)")
        persons[person] = nil
    }

// TODO: возвращать из контейнера сразу собраный tableview чтобы во vc ничего не собирать
}
