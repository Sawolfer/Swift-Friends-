//
//  Event.swift
//  Friends
//
//  Created by тимур on 29.03.2025.
//

import UIKit

enum EventModels {
    struct Event: Codable {
        var id: UUID
        var title: String
        var description: String
        var address: String
        var hostId: UUID
        var attendiesInfo: [AttendeeInfo]
        var isTimeFixed: Bool
        var creationDate: Date
        var startTime: Date?
        var endTime: Date?
        var location: Location?
    }

    struct AttendeeInfo: Codable {
        var id: UUID
        var status: AttendanceStatus
        var pickedCells: Set<TimeGrid.Cell>?
    }

    struct Location: Codable {
        var latitude: Float
        var longitude: Float
    }

    enum AttendanceStatus: String, Codable {
        case attending
        case declined
        case noReply
    }
}

extension EventModels.Event {
    static let empty: EventModels.Event = .init(id: UUID(), title: "", description: "", address: "", hostId: UUID(), attendiesInfo: [], isTimeFixed: false, creationDate: Date())
}
