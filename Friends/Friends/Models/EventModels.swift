//
//  Event.swift
//  Friends
//
//  Created by тимур on 29.03.2025.
//

import UIKit
import MapKit

enum EventModels {
    struct Event {
        var title: String
        var address: String
        var date: Date
        var location: Location
        var hostId: UUID
        var attendiesId: [UUID]
    }

    struct FriendInfo {
        var id: UUID
        var status: GoingStatus
        var pickedCellsForDate: [Date: [Int]]?
    }
    
    struct Location {
        var latitude: Float
        var longitude: Float
    }
}
