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
    @Published var friends = [Person]()
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
    private let friendsProvider = FriendsNetwork()
    private let eventProvider = EventsNetworkCommunications()
    private let cache = AppCache.shared
// TODO: make parsing id from loginned user

    func selectAllCells() {
        for row in 0..<rows {
            for column in 0..<columns {
                let cell = TimeGrid.Cell(row: row, column: column)
                selectedCells.insert(cell)
            }
        }
    }

    func loadFriends() {
        friendsProvider.loadFriends() { [weak self] result in
            switch result {
            case .success(let friends):
                self?.friends = friends
                print(friends)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func addEvent() {
        guard let id = cache.user?.id else {
            print("No id for loadFriends timur")
            return
        }
        event.id = UUID()
        event.hostId = id
        event.attendiesInfo = Array(selectedFriends).map { EventModels.AttendeeInfo(id: $0.id, status: .noReply) }
        event.pickedCells = selectedCells
        eventProvider.addEvent(event)
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
