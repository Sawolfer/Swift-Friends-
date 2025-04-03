//
//  AuthentificationViewController.swift
//  Friends
//
//  Created by тимур on 03.04.2025.
//

import UIKit
import SwiftUI
import SnapKit

final class AuthViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swiftUIView = AuthView()
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hostingController.didMove(toParent: self)
    }
}

