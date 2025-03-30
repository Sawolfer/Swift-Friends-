//
//  Friend.swift
//  Friends
//
//  Created by тимур on 28.03.2025.
//

import UIKit

struct Person: Identifiable {
    let id = UUID()
    let name: String
    let photo: UIImage?
}

#if DEBUG
extension Person {
    static let sampleData: [Person] = [
        Person(name: "Timur", photo: UIImage(named: "image")),
        Person(name: "Alex", photo: UIImage(named: "image1")),
        Person(name: "John", photo: UIImage(named: "image2")),
        Person(name: "Sarah", photo: UIImage(named: "image3")),
        Person(name: "Michael", photo: UIImage(named: "image4")),
        Person(name: "Emily", photo: UIImage(named: "image5")),
    ]
}
#endif
