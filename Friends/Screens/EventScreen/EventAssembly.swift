//
//  EventAssembly.swift
//  Friends
//
//  Created by Алексей on 29.03.2025.
//
import UIKit

final class EventAssembly {
    static func build() -> UIViewController {
        let view = EventViewController()
        let networkManager: EventsNetworkCommunications = EventsNetworkCommunications()
        let dataManager = DataManager(eventNetworkManager: networkManager)
        let presenter = EventPresenter(view: view, dataManager: dataManager)
        view.presenter = presenter

        return view
    }
}
