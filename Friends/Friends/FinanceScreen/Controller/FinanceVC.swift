//
//  FinanceVC.swift
//  Friends
//
//  Created by Алёна Максимова on 26.03.2025.
//

import UIKit

final class FinanceVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let modalViewController = AddExpenseModalViewController()
        let navigationController = UINavigationController(rootViewController: modalViewController)
        navigationController.modalPresentationStyle = .pageSheet
        navigationController.sheetPresentationController?.prefersGrabberVisible = true
        present(navigationController, animated: true)
    }
}
