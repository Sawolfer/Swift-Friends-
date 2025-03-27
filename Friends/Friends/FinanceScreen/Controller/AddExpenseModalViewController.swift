//
//  AddExpenseModalViewController.swift
//  Friends
//
//  Created by Алёна Максимова on 26.03.2025.
//

import UIKit

final class AddExpenseModalViewController: UIViewController {
    
    private var expenseView: AddExpenseModalView {
        guard let view = view as? AddExpenseModalView else {
            fatalError()
        }
        return view
    }
    
    override func loadView() {
        self.view = AddExpenseModalView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expenseView.backgroundColor = .systemGray6
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        expenseView.addGestureRecognizer(tapGesture)
        
        expenseView.typeExpenseControl.addTarget(self, action: #selector(changeTypeExpense), for: .valueChanged)
    }
    
    @objc func changeTypeExpense() {
        expenseView.toggleViews()
    }
    
    @objc func hideKeyboard() {
        expenseView.endEditing(true)
    }
}
