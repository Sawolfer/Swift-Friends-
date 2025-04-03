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

    func selectAllCells() {
        for row in 0..<rows {
            for column in 0..<columns {
                let cell = TimeGrid.Cell(row: row, column: column)
                selectedCells.insert(cell)
            }
        }
    }

    func loadFriends() {
        let id = UUID(uuidString: "FD22EB46-86C7-48FC-9B35-2A916D4BCF17")!
        friendsProvider.loadFriends(id: id) { [weak self] result in
            switch result {
            case .success(let friends):
                self?.friends = friends
                print(friends)
            case .failure(let error):
                print(error.localizedDescription)
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
