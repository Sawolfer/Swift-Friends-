//
//  EvenViewModel.swift
//  Friends
//
//  Created by тимур on 31.03.2025.
//

import SwiftUI

enum UserRole {
    case attendee
    case host
}

final class ViewEventViewModel: ObservableObject {
    // MARK: - Published

    @Published var event = EventModels.Event.empty
    @Published var selectedCells = Set<TimeGrid.Cell>()
    @Published var attendiesInfo = [Person: EventModels.AttendanceStatus]()

    // MARK: - Private properties

    private let eventId: UUID
    private let rows = 16
    private let columns = 7
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    // MARK: - Public properties

    var isHost: Bool {
        return true
    }

    // MARK: - Initializers

    init(eventId: UUID) {
        self.eventId = eventId
    }

    func loadEvent() {
        event = EventModels.Event(title: "Coffee", description: "Coffee", address: "Adress", hostId: UUID(), attendiesInfo: [EventModels.AttendeeInfo(id: UUID(), status: .attending, pickedCells: [TimeGrid.Cell(row: 1, column: 1)])], isTimeFixed: false, creationDate: Date())
        event.attendiesInfo.forEach({ info in
            let person = Person(name: "Masha")
            attendiesInfo[person] = info.status
        })
    }

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
}
