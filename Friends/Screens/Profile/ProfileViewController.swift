//
//  ProfileViewController.swift
//  Friends
//
//  Created by Алёна Максимова on 03.04.2025.
//

import UIKit

final class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.backgroundColor = .background
    }

    override func loadView() {
        self.view = ProfileView()
    }

    private var profileView: ProfileView {
        guard let view = view as? ProfileView else {
            assertionFailure("Failed to dequeue FinanceView")
            return ProfileView()
        }
        return view
    }
}
