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

    @Published var event: EventModels.Event
    @Published var cellsOpacity = [TimeGrid.Cell: Double]()
    @Published var cellFriendLists: [TimeGrid.Cell: [Person]] = [:]
    @Published var selectedCells = Set<TimeGrid.Cell>()
    @Published var attendiesInfo = [(Person, EventModels.AttendanceStatus)]()

    // MARK: - Private properties

    private let rows = 16
    private let columns = 7
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private let peopleProvider = PeopleNetwork()
    private let id = UUID(uuidString: "3320018A-B889-46F4-B895-D5A799AFC53A")!

    // MARK: - Public properties

    var isHost: Bool {
        return event.hostId == id
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

    var myStatus: EventModels.AttendanceStatus {
        for info in attendiesInfo {
            if info.0.id == id {
                return info.1
            }
        }

        return .noReply
    }

    // MARK: - Initializers

    init(event: EventModels.Event) {
        self.event = event
    }

    func loadFriends() {
        let group = DispatchGroup()
        var loadedPeople: [Person] = []
        var host = Person(id: UUID(), name: "", username: "", password: "", debts: [])

        group.enter()
        peopleProvider.findUser(by: event.hostId) { result in
            defer { group.leave() }
            switch result {
            case .success(let person):
                host = person
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        event.attendiesInfo.forEach { info in
            group.enter()
            peopleProvider.findUser(by: info.id) { result in
                defer { group.leave() }
                switch result {
                case .success(let person):
                    DispatchQueue.main.async {
                        loadedPeople.append(person)
                        self.attendiesInfo.append((person, info.status))

                        if let selectedCells = info.pickedCells {
                            selectedCells.forEach { cell in
                                self.cellFriendLists[cell, default: []].append(person)
                            }
                        }
                    }
                case .failure(let error):
                    print("Failed to load user: \(error)")
                }
            }
        }

        group.notify(queue: .main) {
            // Add host to selected cells
            for cell in self.selectedCells {
                self.cellFriendLists[cell, default: []].append(host)
            }

            // Calculate max count
            let maxCount = self.cellFriendLists.values.map { $0.count }.max() ?? 1

            // Update opacities
            for (cell, people) in self.cellFriendLists {
                self.cellsOpacity[cell] = Double(people.count) / Double(maxCount)
            }

            print(self.cellsOpacity)
        }
    }

    func isTimePicked() -> Bool {
        for info in attendiesInfo {
            if info.0.id == id {
                return info.1 != .noReply
            }
        }

        return false
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
