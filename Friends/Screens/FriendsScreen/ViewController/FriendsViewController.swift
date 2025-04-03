//
//  FriendsViewController.swift
//  Friends
//
//  Created by Алексей on 02.04.2025.
//

import UIKit
import SwiftUI
import SnapKit

final class FriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        let viewModel = FriendsViewModel()
        let swiftUIView = FriendsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        hostingController.didMove(toParent: self)
    }

    private func setupNavigationBar() {
        title = "Группы"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FriendsViewController())
}
