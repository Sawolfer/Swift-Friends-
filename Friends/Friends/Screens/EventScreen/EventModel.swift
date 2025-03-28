//
//  EventModel.swift
//  Friends
//
//  Created by Алексей on 26.03.2025.
//

import UIKit
import MapKit

final class EventModel {
    // MARK: - Variables
    var title: String = "Lectures"
    var address: String = "Sirius University"
    var date: String = "10:00 Mar 28"
    var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 43.414516, longitude: 39.950750)
    var region: MKCoordinateRegion
    var friendsImages: [UIImage?] = [
        UIImage(named: "image"),
        UIImage(named: "image3"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2"),
        UIImage(named: "image2")
    ]
    var goingStatus: GoingStatus = GoingStatus.awaiting
    
    // MARK: - Lifecycle
    init() {
        self.region = MKCoordinateRegion(
            center: location,
            latitudinalMeters: 250,
            longitudinalMeters: 250
        )
    }
    
    init(title: String, address: String, date: String, location: CLLocationCoordinate2D,
         region: MKCoordinateRegion, friendsImages: [UIImage?], status: GoingStatus) {
        self.title = title
        self.address = address
        self.date = date
        self.location = location
        self.region = region
        self.friendsImages = friendsImages
        self.goingStatus = status
    }
}
