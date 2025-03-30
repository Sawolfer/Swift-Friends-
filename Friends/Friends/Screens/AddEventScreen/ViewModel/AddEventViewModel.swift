//
//  AddEventViewModel.swift
//  Friends
//
//  Created by тимур on 27.03.2025.
//

import SwiftUI

final class AddEventViewModel: ObservableObject {
    @Published var event: EventModel
    @Published var selectedTimeOption: String = "Exact time"
    @Published var selectedCells: Set<ScheduleMatrix.Cell> = []
    var rows: Int = 0
    var columns: Int = 0
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    private let generator = UIImpactFeedbackGenerator(style: .medium)

    init(rows: Int, columns: Int, event: EventModel) {
        self.event = event
        self.rows = rows
        self.columns = columns
    }

    func selectAllCells() {
        for row in 0..<rows {
            for column in 0..<columns {
                let cell = ScheduleMatrix.Cell(row: row, column: column)
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
