//
//  Debt.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit

enum Color {
    case red
    case green

    static func getColor(isDebitor: Bool) -> UIColor{
        switch isDebitor {
            case true:
                return .green
            case false:
                return .red
        }
    }
}
struct Debt: Identifiable {
    var personTo: Person
    var personFrom: Person
    var debt: Double
    let id = UUID()
}
enum DebtType {
    case from
    case to
}
