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
    @Published var friends: [Person] = []
    @Published var selectedFriends: Set<UUID> = []
    @Published var selectedCells: Set<TimeGrid.Cell> = []
    @Published var addLocation: Bool = false
    @Published var locationText: String = ""
    private lazy var completer = MKLocalSearchCompleter()
    private lazy var searchResults: [(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D?)] = []
    private var searchCompletion: (([(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D?)]) -> Void)?
    private var userRegionCoordinate: CLLocationCoordinate2D?
    var selectedFriendsList: [Person] {
        friends.filter { selectedFriends.contains($0.id) }
    }

    var rows: Int
    var columns: Int
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
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

    func hapticFeedback() {
        generator.impactOccurred()
    }
}

extension AddEventViewModel: MKLocalSearchCompleterDelegate {
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results.compactMap { result in
            let street = result.title
            let subtitle = result.subtitle
            let searchRequest = MKLocalSearch.Request(completion: result)
            let coordinate = searchRequest.region.center

            return (title: street, subtitle: subtitle, coordinate: coordinate)
        }
        print(searchResults)
        searchCompletion?(searchResults)
    }

    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        searchResults = []
        searchCompletion?(searchResults)
    }
}
