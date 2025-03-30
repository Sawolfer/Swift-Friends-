//
//  Friend.swift
//  Friends
//
//  Created by тимур on 28.03.2025.
//

import UIKit

struct Person: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let photo: String?
}

#if DEBUG
extension Person {
    static let sampleData = [
        Person(name: "Timur", photo: "image"),
        Person(name: "Alex", photo: "image1"),
        Person(name: "John", photo: "image2"),
        Person(name: "Sarah", photo: "image3"),
        Person(name: "Michael", photo: "image4"),
        Person(name: "Emily", photo: "image5")
    ]
}
#endif
