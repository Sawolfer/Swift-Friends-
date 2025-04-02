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
    @Published var cellsOpacity = [TimeGrid.Cell: Double]()
    @Published var cellFriendLists: [TimeGrid.Cell: [Person]] = [:]
    @Published var selectedCells = Set<TimeGrid.Cell>()
    @Published var attendiesInfo = [(Person, EventModels.AttendanceStatus)]()

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

    var title: String {
        if isHost {
            return event.isTimeFixed ? "View Event" : "Choose Time"
        }

        return "View Event"
    }

    var headerButtonText: String {
        "Confirm"
    }

    // MARK: - Initializers

    init(eventId: UUID) {
        self.eventId = eventId
    }

    func loadEvent() {
        event = EventModels.Event(title: "Coffee", description: "Coffee", address: "Adress", hostId: UUID(), attendiesInfo: [
            EventModels.AttendeeInfo(id: UUID(), status: .attending, pickedCells: [TimeGrid.Cell(row: 1, column: 1)]),
            EventModels.AttendeeInfo(id: UUID(), status: .noReply, pickedCells: [TimeGrid.Cell(row: 1, column: 1)]),
            EventModels.AttendeeInfo(id: UUID(), status: .declined, pickedCells: [TimeGrid.Cell(row: 1, column: 1)])
        ], isTimeFixed: false, creationDate: Date())
        attendiesInfo = event.attendiesInfo.map({ info in
            (Person(name: "Masha"), info.status)
        })

        event.attendiesInfo.forEach { info in
            if let pickedCells = info.pickedCells {
                pickedCells.forEach { cell in
                    cellFriendLists[cell]?.append(info.id)
                }
            }
        }
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

    func isMe(id: UUID) -> Bool {
        return id == UUID(uuidString: "1")
    }
}
