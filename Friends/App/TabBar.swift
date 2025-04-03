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

        setupUI()
    }

    private func setupUI() {
        let firstViewController = UINavigationController(rootViewController: FinanceViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "Деньги",
                                                      image: UIImage(systemName: "creditcard"),
                                                      selectedImage: UIImage(systemName: "creditcard.fill"))

        let secondViewController = UINavigationController(rootViewController: EventAssembly.build())
        secondViewController.tabBarItem = UITabBarItem(title: "Встречи",
                                                       image: UIImage(systemName: "person.3"),
                                                       selectedImage: UIImage(systemName: "person.3.fill"))

        let thirdViewController = UINavigationController(rootViewController: FriendsViewController())
        thirdViewController.tabBarItem = UITabBarItem(title: "Друзья",
                                                       image: UIImage(systemName: "person"),
                                                       selectedImage: UIImage(systemName: "person"))

        viewControllers = [firstViewController, secondViewController, thirdViewController]

        selectedIndex = 0
    }

}
