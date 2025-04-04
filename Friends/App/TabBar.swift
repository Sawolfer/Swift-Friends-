//
//  TabBar.swift
//  Friends
//
//  Created by Савва Пономарев on 27.03.2025.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserLoginStatus()
    }

    private func checkUserLoginStatus() {
        DispatchQueue.main.async { [weak self] in
            let userDataCache = UserDataCache()
            if let userData = userDataCache.retrieveUserInfo() {
                self?.setupUI()
            } else {
                self?.presentAuthController()
            }
        }
    }

    private func presentAuthController() {
        let authVC = AuthViewController()
        authVC.onAuthSuccess = { [weak self] in
            self?.setupUI()
        }
        let navController = UINavigationController(rootViewController: authVC)
        navController.modalPresentationStyle = .overFullScreen
        present(navController, animated: true)
    }

    private func setupUI() {
        let firstViewController = UINavigationController(rootViewController: FinanceViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "Деньги",
                                                      image: UIImage(systemName: "creditcard"),
                                                      selectedImage: UIImage(systemName: "creditcard.fill"))

        let secondViewController = UINavigationController(rootViewController: EventAssembly.build())
        secondViewController.tabBarItem = UITabBarItem(title: "Встречи",
                                                       image: UIImage(systemName: "balloon.2"),
                                                       selectedImage: UIImage(systemName: "balloon.2.fill"))

        let thirdViewController = UINavigationController(rootViewController: FriendsViewController())
        thirdViewController.tabBarItem = UITabBarItem(title: "Друзья",
                                                       image: UIImage(systemName: "person.2"),
                                                       selectedImage: UIImage(systemName: "person.2.fill"))

        viewControllers = [firstViewController, secondViewController, thirdViewController]

        selectedIndex = 0
    }
}
