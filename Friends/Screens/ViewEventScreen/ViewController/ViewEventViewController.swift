//
//  ViewEventViewController.swift
//  Friends
//
//  Created by тимур on 03.04.2025.
//

import UIKit
import SwiftUI
import SnapKit

final class ViewEventViewController: UIViewController {
    let event: EventModels.Event

    init(event: EventModels.Event) {
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = ViewEventViewModel(event: event)
        let swiftUIView = ViewEventView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hostingController.didMove(toParent: self)
    }
}
