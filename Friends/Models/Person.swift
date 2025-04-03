//
//  Person.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.

import UIKit

struct Person: Codable {
    var id: UUID
    var name: String
    var imageURL: URL?
    var friends: [UUID] = []
    var debts: [Debt]

    var icon: UIImage {
        if let imageURL = imageURL,
            let imageData = try? Data(contentsOf: imageURL),
            let image = UIImage(data: imageData)
        {
            return image
        }
        return UIImage(systemName: "person.circle")!
    }
}
//MARK: - Equatable
extension Person: Identifiable, Equatable, Hashable {}
