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

    var onAuthSuccess: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = AuthViewModel()
        viewModel.onAuthSuccess = { [weak self] in
            self?.dismiss(animated: true) {
                self?.onAuthSuccess?() // Notify `TabBarController` after closing
            }
        }

        let swiftUIView = AuthView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hostingController.didMove(toParent: self)
    }
}
