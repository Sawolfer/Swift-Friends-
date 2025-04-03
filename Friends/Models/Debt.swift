//
//  Debt.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import UIKit

enum DebtColor {
    case red
    case green

    static func getColor(isDebitor: Bool) -> UIColor {
        return isDebitor ? .green : .red
    }
}
struct Debt: Identifiable, Hashable, Codable {
    var personTo: Person
    var personFrom: Person
    var debt: Double
    var id = UUID()
}
enum DebtType {
    case from
    case to
}
