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

        let viewModel = FriendsViewModel()
        let swiftUIView = FriendsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        view.addSubview(hostingController.view)

        view.backgroundColor = .background
        hostingController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }

        hostingController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.subviews.forEach({ subview in
                if subview is UILabel {
                    subview.removeFromSuperview()
                }
            })
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false

        let titleLabel = UILabel()
        titleLabel.text = "Друзья"
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(navigationBar.snp.leading).offset(16)
                make.centerY.equalTo(navigationBar.snp.centerY)
                make.trailing.lessThanOrEqualTo(navigationBar.snp.trailing).offset(-16)
            }
        }

        let avatarButton = UIButton(type: .custom)
        avatarButton.setImage(UIImage(named: "image"), for: .normal) // TODO: load user image
        avatarButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        avatarButton.clipsToBounds = true
        avatarButton.layer.cornerRadius = 20

        avatarButton.addAction(UIAction { [weak self] _ in
            let profileVC = ProfileViewController()
            self?.navigationItem.backButtonTitle = "Назад"
            self?.navigationController?.pushViewController(profileVC, animated: true)
        }, for: .touchUpInside)

        let buttonContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        buttonContainerView.addSubview(avatarButton)

        avatarButton.center = CGPoint(x: buttonContainerView.bounds.midX, y: buttonContainerView.bounds.midY)

        let barButtonItem = UIBarButtonItem(customView: buttonContainerView)
        navigationItem.rightBarButtonItem = barButtonItem

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .background
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: FriendsViewController())
}
