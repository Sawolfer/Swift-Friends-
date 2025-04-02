//
//  AddEventViewModel.swift
//  Friends
//
//  Created by тимур on 27.03.2025.
//

import SwiftUI
import MapKit

final class AddEventViewModel: NSObject, ObservableObject {
    @Published var event = EventModels.Event.empty
    @Published var friends = [
        Person(name: "Lexa", imageURL: URL(filePath: "https://www.fakepersongenerator.com/Face/female/female1023241532165.jpg")!),
        Person(name: "Maya", imageURL: URL(filePath: "https://www.fakepersongenerator.com/Face/female/female1023241532165.jpg")!),
        Person(name: "Jane", imageURL: URL(filePath: "https://www.fakepersongenerator.com/Face/female/female1023241532165.jpg")!)
    ]
    @Published var selectedFriends = Set<Person>()
    @Published var selectedCells: Set<TimeGrid.Cell> = []
    @Published var addLocation: Bool = false
    @Published var locationText: String = ""

    let rows = 16
    let columns = 7
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    func selectAllCells() {
        for row in 0..<rows {
            for column in 0..<columns {
                let cell = TimeGrid.Cell(row: row, column: column)
                selectedCells.insert(cell)
            }
        }
    }

    func clearCells() {
        selectedCells = []
    }

    func getFormattedDate(from date: Date) -> String {
        dateFormatter.string(from: date)
    }

    func hapticFeedback() {
        generator.impactOccurred()
    }
}
