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
    var title: String = ""
    var description: String = ""
    var address: String = "Moscow, Tverskaya 11"
    var date: String = "13:00 Aug 13"
    var location: MKMapView = MKMapView()
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
        UIImage(named: "image2"),
    ]
    var goingStatus: GoingStatus = GoingStatus.awaiting
    
    // MARK: - Lifecycle
    init() {
        
    }
    
    init(title: String, address: String, date: String, location: MKMapView, status: GoingStatus) {
        self.title = title
        self.address = address
        self.date = date
        self.location = location
        self.goingStatus = status
    }
}
