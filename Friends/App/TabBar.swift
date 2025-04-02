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
        firstViewController.tabBarItem = UITabBarItem(title: "Деньги", image: UIImage(systemName: "creditcard"),
                                                      selectedImage: UIImage(systemName: "creditcard.fill"))

//        TODO: указать экран встреч и выбора времени 
//        let secondViewController = UINavigationController(rootViewController: EventViewController())
//        secondViewController.tabBarItem = UITabBarItem(title: "Встречи", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))
//
//        let thirdViewController: UIViewController = UIHostingController(rootView: AboutView())
//        thirdViewController.tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(systemName: "ca;endar"), selectedImage: UIImage(systemName: "calendar.fill"))

        viewControllers = [firstViewController]

        selectedIndex = 0
    }

}
