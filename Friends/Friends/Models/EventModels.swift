//
//  Event.swift
//  Friends
//
//  Created by тимур on 29.03.2025.
//

import UIKit

enum EventModels {
    struct Event {
        var title: String
        var description: String
        var address: String
        var date: Date
        var location: Location
        var hostId: UUID
        var attendiesId: [UUID]
    }

    struct FriendInfo {
        var id: UUID
        var status: AttendanceStatus
        var pickedCellsForDate: [Date: [Int]]?
    }

    struct Location {
        var latitude: Float
        var longitude: Float
    }

    enum AttendanceStatus {
        case ttending
        case declined
        case noReply
    }
}

extension EventModels.Event {
    static let empty: EventModels.Event = .init(
        title: "",
        description: "",
        address: "",
        date: Date(),
        location: .init(latitude: 0, longitude: 0),
        hostId: UUID(),
        attendiesId: []
    )
}
