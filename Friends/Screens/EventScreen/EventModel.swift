//
//  EventModel.swift
//  Friends
//
//  Created by Алексей on 26.03.2025.
//

import UIKit
import MapKit

struct EventModel {
    var title: String
    var address: String
    var date: String
    var location: CLLocationCoordinate2D
    var region: MKCoordinateRegion
    var friendsImages: [UIImage?] = []
    var status: GoingStatus = GoingStatus.awaiting
}
