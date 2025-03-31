//
//  AddEventViewController.swift
//  Friends
//
//  Created by тимур on 28.03.2025.
//

import UIKit
import SwiftUI
import SnapKit

class AddEventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = AddEventView()
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hostingController.didMove(toParent: self)
    }
}

@available(iOS 17.0, *)
#Preview {
    AddEventViewController()
}
